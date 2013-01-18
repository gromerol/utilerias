function createRegisterView() {
    var view = Ti.UI.createView({
        backgroundColor: '#fff',
        top: 20+u, right: 20+u, bottom: 20+u, left: 20+u,
        borderColor: '#000', borderWidth: 2,
        zIndex: UI.zIndexLevels.dialog
    });
    var content = Ti.UI.createScrollView({
        contentHeight: 'auto',
        layout: 'vertical'
    });
    view.add(content);

    var status = Ti.UI.createLabel({
        text: 'What should your email and password be?',
        top: 10+u, left: 30+u, right: 30+u,
        color: '#000', textAlign: 'left',
        height: Ti.UI.SIZE || 'auto'
    });
    content.add(status);

    var email = Ti.UI.createTextField({
        hintText: 'Email',
        top: 10+u, left: 10+u, right: 10+u,
        height: 40+u,
        borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED
    });
    content.add(email);

    var password = Ti.UI.createTextField({
        hintText: 'Password',
        top: 10+u, left: 10+u, right: 10+u,
        height: 40+u,
        borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
        passwordMask: true
    });
    content.add(password);

    var register = Ti.UI.createButton({
        title: 'Register',
        top: 10+u, left: 10+u, right: 10+u, bottom: 10+u,
        height: 40+u
    });
    content.add(register);

    var loading = getLoadingView();
    content.add(loading);
    loading.hide();

    var fields = [ email, password ];
    function submitForm() {
        for (var i = 0; i < fields.length; i++) {
            if (!fields[i].value.length) {
                fields[i].focus();
                return;
            }
            fields[i].blur();
        }
        register.hide();
        loading.show();
        Box.registerUser({
            username: email.value,
            password: password.value,
            success: function() {
                UI.fadeIn(createLoggedInView());
                UI.popOut(view);
                Ti.App.fireEvent('loggedIn', {});
            },
            error: function(evt) {
                alert(evt.error);
                loading.hide();
                register.show();
            }
        });
    }

    register.addEventListener('click', submitForm);
    for (var i = 0; i < fields.length; i++) {
        fields[i].addEventListener('return', submitForm);
    }

    view.addEventListener('open', function() {
        email.focus();
    });

    return view;
}