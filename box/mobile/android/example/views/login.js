function createLoginView() {
    var view = Box.createLoginView({
        backgroundColor: '#fff',
        top: 20+u, right: 20+u, bottom: 20+u, left: 20+u,
        borderColor: '#000', borderWidth: 2,
        zIndex: UI.zIndexLevels.dialog
    });
    Box.login({
        view: view,
        success: function() {
            UI.fadeIn(createLoggedInView());
            UI.popOut(view);
            Ti.App.fireEvent('loggedIn', {});
        },
        error: function(evt) {
            if (evt.error) {
                alert(evt.error);
            }
            else {
                alert('Failed to login! Please try again.');
            }
            UI.popOut(view);
        }
    });
    return view;
}