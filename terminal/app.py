import urwid
import json
import urllib.request

# choices = u'Chapman Cleese Gilliam Idle Jones Palin'.split()


def get_users():
    with urllib.request.urlopen("http://localhost:8888/api/users") as f:
        response = json.loads(f.read().decode())
        user_list = response.get('users')
    if user_list:
        user_dict = {}
        for user in user_list:
            user_dict.update({user['username']: user['mobile']})
    else:
        raise urwid.ExitMainLoop()
    return user_dict

user_dict = get_users()
choices = user_dict.keys()
select_user = None
current_user = None


def login(user):
    with urllib.request.urlopen("http://localhost:8888/api/login", data='{mobile=%s, password=%s}') as f:
        response = json.loads(f.read().decode())
        user_list = response.get('users')
    if user_list:
        user_dict = {}
        for user in user_list:
            user_dict.update({user['username']: user['mobile']})
    else:
        raise urwid.ExitMainLoop()
    return user_dict


def choose_user(title, choices):
    body = [urwid.Text(title), urwid.Divider()]
    for c in choices:
        button = urwid.Button(c)
        urwid.connect_signal(button, 'click', login_page, c)
        body.append(urwid.AttrMap(button, None, focus_map='reversed'))
    return urwid.ListBox(urwid.SimpleFocusListWalker(body))


def login_page(button, username):
    global current_user
    current_user = {'username': username, 'mobile': user_dict.get(username)}
    response = urwid.Text([username])
    w = urwid.Edit('请输入密码: ', '')
    w = urwid.AttrWrap(w, 'edit')
    done = urwid.Button(u'登陆')
    urwid.connect_signal(done, 'click', exit_program, w.get_w().get_edit_text())
    main.original_widget = urwid.Filler(urwid.Pile([response, w,
        urwid.AttrMap(done, None, focus_map='reversed')]))


def after_login(button, password):
    # with open("a.txt", 'w') as f:
    #     f.write(password)

    # print(password)
    # # raise urwid.ExitMainLoop()
    # response = urwid.Text([password])
    # w = urwid.Edit('请输入密码: ', '')
    # w = urwid.AttrWrap(w, 'edit')
    # done = urwid.Button(u'登陆')
    # urwid.connect_signal(done, 'click', exit_program, w.get_text())
    # main.original_widget = urwid.Filler(urwid.Pile([response, w,
    #     urwid.AttrMap(done, None, focus_map='reversed')]))


main = urwid.Padding(choose_user(u'请登录', choices), left=2, right=2)
top = urwid.Overlay(main, urwid.SolidFill(u'\N{MEDIUM SHADE}'),
    align='center', width=('relative', 60),
    valign='middle', height=('relative', 60),
    min_width=20, min_height=9)
urwid.MainLoop(top, palette=[('reversed', 'standout', '')]).run()
