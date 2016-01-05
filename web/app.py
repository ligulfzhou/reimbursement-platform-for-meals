import base64
import time
import logging
from flask import Flask, render_template, request, g, jsonify, make_response, redirect
from flask.ext.pymongo import PyMongo
from flask.ext.httpauth import HTTPBasicAuth

app = Flask(__name__)
app.config['MONGO_DINGCAN'] = '127.0.0.1:27017'
app.config['MONGO_DBNAME'] = 'dingcan'
mongo = PyMongo(app, config_prefix='MONGO')

auth = HTTPBasicAuth()
logging.basicConfig(filename='dingcan.log', level=logging.DEBUG)


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
    # 404也跳转到首页
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


@app.route('/api/users')
def get_users():
    users = list(mongo.db.user.find({}, {'_id': 0, 'password': 0}))
    # users_data = [
    #         {'username': user['username'],
    #             'mobile': user['mobile']} for user in users]
    return make_response(jsonify({'users': users}))


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
        return make_response(jsonify({'canfei': 'error'}))
    year, month, day = date.split('-')
    canfei = mongo.db.canfei.find_one(
        {'mobile': g.current_user['mobile'], 'month': '%s-%s' % (year, int(month)), 'day': '%s' % int(day)}, {'_id': 0})
    if canfei:
        return make_response(jsonify({'canfei': 'error_chongfu'}))
    canfei_data = {
        'username': g.current_user['username'],
        'mobile': g.current_user['mobile'],
        'month': '%s-%s' % (year, int(month)),
        'day': '%s' % int(day),
        'money': money,
        'created': round(time.time())
    }
    mongo.db.canfei.insert(canfei_data)
    return make_response(jsonify({'canfei': 'success'}))


@app.route('/api/statistics')
@auth.login_required
def statistic():
    flag = int(request.args.get('flag', None) or 0)
    if flag:
        timestruct = time.localtime(time.time() - 30 * 24 * 60 * 60)
    else:
        timestruct = time.localtime(time.time())
    year, month = timestruct.tm_year, timestruct.tm_mon
    if g.current_user['mobile'] == '15201263650':
        try:
            statistics = mongo.db.canfei.aggregate([{'$match': {'month': '%s-%s' % (year, month)}},
                                                    {'$group': {'_id': '$username', 'money': {'$sum': '$money'}}}])
            total = sum([statistic['money'] for statistic in statistics['result']])
            return make_response(jsonify({'statistics': statistics['result'], 'total': total}))
        except Exception as e:
            logging.error(e)
            return
    else:
        statistics = list(mongo.db.canfei.find({'mobile': g.current_user['mobile'], 'month': '%s-%s' % (year, month)},
                                               {'_id': 0}).sort([('created', -1)]))
        total = sum([statistic['money'] for statistic in statistics])
        return make_response(jsonify({'statistics': statistics, 'total': total}))


@app.route('/api/user_statistics')
@auth.login_required
def user_statistic():
    username = request.args.get('username', '')
    flag = int(request.args.get('flag', None) or 0)
    if not username:
        return make_response(jsonify({'user_statistics': 'error_req'}))
    if flag:
        timestruct = time.localtime(time.time() - 30 * 24 * 60 * 60)
    else:
        timestruct = time.localtime(time.time())
    year, month = timestruct.tm_year, timestruct.tm_mon
    if g.current_user['mobile'] == '15201263650':
        statistics = list(mongo.db.canfei.find({'username': username, 'month': '%s-%s' % (year, month)},
                                               {'_id': 0}).sort([('created', -1)]))
        total = sum([statistic['money'] for statistic in statistics])
        return make_response(jsonify({'statistics': statistics, 'total': total}))
    else:
        return make_response(jsonify({'user_statistics': 'error_permission'}))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8888, debug=True)
