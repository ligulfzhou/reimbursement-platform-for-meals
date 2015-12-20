import base64
import time
from flask import Flask, render_template, request, g, jsonify, make_response, redirect
from flask.ext.pymongo import PyMongo
from flask.ext.httpauth import HTTPBasicAuth

app = Flask(__name__)
app.config['MONGO_DINGCAN'] = '127.0.0.1:27017'
app.config['MONGO_DBNAME'] = 'dingcan'
mongo = PyMongo(app, config_prefix='MONGO')

auth = HTTPBasicAuth()


@auth.verify_password
def verify_passwd(mobile, password2):
    user = mongo.db.user.find_one({'mobile': mobile})
    if user and user['password'] == password2:
        g.current_user = user
        return True
    else:
        return False


@auth.error_handler
def unauthorized():
    # 未登陆跳到首页
    return redirect('/')


@app.errorhandler(404)
def not_found(error):
    return redirect('/')


@app.route('/')
def index():
    if request.method == 'GET':
        users = list(mongo.db.user.find({}, {'_id': 0}))
        return render_template('login.html', users=users)


@app.route('/add')
def add_page():
    return render_template('add.html')


@app.route('/statistic')
def statistic_page():
    return render_template('statistic.html')


@app.route('/api/login', methods=['POST'])
def login():
    mobile = request.form.get('mobile', '')
    password = request.form.get('password', '')
    if not mobile or not password:
        return make_response(jsonify({'login': 'error'}))
    user = mongo.db.user.find_one({'mobile': mobile})
    if user and user['password'] == password:
        user_data = {
            'mobile': user['mobile'],
            'username': user['username'],
            'token': base64.b64encode(bytes('%s:%s' % (user['mobile'], user['password']), 'utf-8')).decode()
        }
        return make_response(jsonify({'user': user_data}))
    else:
        return make_response(jsonify({'login': 'error'}))


@app.route('/api/add_canfei', methods=['POST'])
@auth.login_required
def add_canfei():
    date = request.form.get('date', '')
    money = int(request.form.get('money', None) or 0)
    if not date or not money:
        return jsonify({'add canfei': 'error'})
    year, month, day = date.split('-')
    canfei_data = {
        'user': g.current_user['mobile'],
        'month': '%s-%s' % (year, month),
        'day': day,
        'money': money,
        'created': round(time.time())
    }
    mongo.db.canfei.insert(canfei_data)
    return jsonify({'canfei': 'success'})


@app.route('/api/statistic')
@auth.login_required
def statistic():
    timestruct = time.localtime(time.time())
    year, month = timestruct.tm_year, timestruct.tm_mon
    statistics = list(mongo.db.canfei.find({'user': g.current_user['mobile'], 'month': '%s-%s' % (year, month)},
                                           {'_id': 0}).sort([('created', -1)]))
    return jsonify({'statistics': statistics})

if __name__ == '__main__':
    app.run(port=9999, debug=True)
