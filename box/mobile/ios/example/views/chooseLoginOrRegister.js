function createChooseLoginOrRegisterView() {
    var view = Ti.UI.createView({
        backgroundColor: '#fff'
    });
    view.add(Ti.UI.createLabel({
        text: 'To interact with Box.net, you must first login or register:',
        top: 10+u, left: 10+u, right: 10+u,
        height: 100+u,
        color: '#000'
    }));

    var login = Ti.UI.createButton({
        title: 'Login',
        top: 110+u, left: 30+u,
        width: '40%', height: 40+u
    });
    login.addEventListener('click', function() {
        UI.popIn(createLoginView());
    });
    view.add(login);

    var register = Ti.UI.createButton({
        title: 'Register',
        top: 110+u, right: 30+u,
        width: '40%', height: 40+u
    });
    register.addEventListener('click', function() {
        UI.popIn(createRegisterView());
    });
    view.add(register);

    Ti.App.addEventListener('loggedIn', function() {
        UI.remove(view);
    });

    return view;
}