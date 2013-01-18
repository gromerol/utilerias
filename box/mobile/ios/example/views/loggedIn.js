function createLoggedInView() {
    var view = Ti.UI.createView({
        backgroundColor: '#fff'
    });

    var loading = getLoadingView();
    view.add(loading);

    setTimeout(function() {
        var rootDirectoryView = getDirectoryView();
        view.actions = rootDirectoryView.actions;
        rootDirectoryView.bottom = 70+u;
        view.add(rootDirectoryView);
        loading.hide();
    }, 1);

    var usedSpace = Ti.UI.createLabel({
        text: 'Used ' + bytesToStringSize(Box.user.storageUsed)
            + ' of ' + bytesToStringSize(Box.user.storageQuota),
        textAlign: 'center',
        color: '#000',
        bottom: 40+u, left: 10+u, right: 10+u,
        height: 25+u
    });
    usedSpace.addEventListener('click', function() {
        UI.popIn(getUpdatesView());
    });
    view.add(usedSpace);

    var logout = Ti.UI.createButton({
        title: 'Logout (' + Box.user.userName + ')',
        bottom: 10+u, left: 10+u, right: 10+u,
        height: 25+u
    });
    logout.addEventListener('click', function() {
        Box.logout();
        UI.remove(view);
        UI.add(createChooseLoginOrRegisterView());
    });
    view.add(logout);

    return view;
}