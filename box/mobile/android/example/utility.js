function confirm(options) {
    var dialog = Ti.UI.createAlertDialog({
        title: options.title || 'Confirmation',
        message: options.message || 'Are you sure?',
        buttonNames: [options.action || 'OK', 'Cancel'],
        cancel: 1
    });
    dialog.addEventListener('click', function (evt) {
        if (evt.index == 0) {
            (options.proceed || function () { })();
        }
    });
    dialog.show();
}

function popInView(view) {
    // add a close button to it
    var closeButton = Ti.UI.createButton({
        font: { fontSize: 16 + u, fontWeight: 'bold' },
        color: '#fff', backgroundColor: '#000', borderColor: '#555',
        title: 'X', style: 0,
        borderRadius: 6,
        top: -4 + u, right: -4 + u,
        width: 30 + u, height: 30 + u,
        zIndex: 5
    });
    closeButton.addEventListener('click', function () {
        UI.popOut(view);
    });
    view.add(closeButton);

    if (Ti.Android) {
        UI.add(view);
        view.fireEvent('open');
    }
    else {
        // position the view so that it is hidden
        view.opacity = 0;
        view.transform = Ti.UI.create2DMatrix().scale(0);
        UI.add(view);
        // animate it so it pops out of the screen
        var tooBig = Ti.UI.createAnimation({
            opacity: 1, transform: Ti.UI.create2DMatrix().scale(1.1),
            duration: 350
        });
        var shrinkBack = Ti.UI.createAnimation({
            transform: Ti.UI.create2DMatrix(),
            duration: 400
        });
        tooBig.addEventListener('complete', function () {
            view.animate(shrinkBack);
        });
        shrinkBack.addEventListener('complete', function () {
            view.fireEvent('open');
        });
        view.animate(tooBig);
    }
}

function popOutView(view) {
    if (Ti.Android) {
        view.fireEvent('close');
        UI.remove(view);
    }
    else {
        var hide = Ti.UI.createAnimation({
            opacity: 0, transform: Ti.UI.create2DMatrix().scale(0),
            duration: 400
        });
        hide.addEventListener('complete', function () {
            view.fireEvent('close');
            UI.remove(view);
        });
        view.animate(hide);
    }
}

function fadeInView(view) {
    UI.add(view);
    view.opacity = 0;
    var fade = Ti.UI.createAnimation({
        opacity: 1,
        duration: 500
    });
    fade.addEventListener('complete', function () {
        view.fireEvent('open');
    });
    view.animate(fade);
}
function fadeOutView(view) {
    var fade = Ti.UI.createAnimation({
        opacity: 0,
        duration: 500
    });
    fade.addEventListener('complete', function () {
        view.fireEvent('close');
        UI.remove(view);
    });
    view.animate(fade);
}

function getLoadingView() {
    var loading = Ti.UI.createImageView({
        images: [
            'images/loading/00.png', 'images/loading/01.png', 'images/loading/02.png',
            'images/loading/03.png', 'images/loading/04.png', 'images/loading/05.png',
            'images/loading/06.png', 'images/loading/07.png', 'images/loading/08.png',
            'images/loading/09.png', 'images/loading/10.png', 'images/loading/11.png'
        ],
        width: 33 + u, height: 33 + u
    });
    loading.start();
    return loading;
}

function getRow(obj) {
    var row = Ti.UI.createTableViewRow({
        height: 45 + u
    });
    row.add(Ti.UI.createLabel({
        text: obj.title,
        color: obj.color,
        textAlign: 'left',
        left: 10 + u, right: 10 + u
    }));
    return row;
}

function bindAndroidMenuButton() {
    var possibleActions = [
        'Upload', 'Create Folder', 'Download', 'Comments', 'Move', 'Rename', 'Remove', 'Copy', 'Public Share',
        'Private Share', 'Public Unshare'
    ];
    win.activity.onCreateOptionsMenu = function (e) {
        var menu = e.menu;
        for (var i = 0; i < possibleActions.length; i++) {
            var item = menu.add({ title: possibleActions[i], itemId: i });
            item.addEventListener('click', function (e) {
                var visible = UI.viewStack[UI.viewStack.length - 1];
                visible.actions[e.source.title]();
            });
        }
    };
    win.activity.onPrepareOptionsMenu = function (e) {
        var menu = e.menu;
        var visible = UI.viewStack[UI.viewStack.length - 1];
        for (var i = 0; i < possibleActions.length; i++) {
            var hasAction = (visible && visible.actions && visible.actions[possibleActions[i]]) != undefined;
            menu.findItem(i).setVisible(hasAction);
        }
    };
}

function getActionsView(obj, view) {

    var actions = {};

    // Here are all of the folder specific actions
    if (obj.isFolder) {
        actions['Upload'] = function () {
            Ti.Media.openPhotoGallery({
                success: function (event) {
                    var loading = getLoadingView();
                    view.add(loading);
                    var image = event.media;
                    var uploadFrom = Ti.Filesystem.getFile(Ti.Filesystem.applicationDataDirectory, new Date().getTime() + '.jpg');
                    uploadFrom.write(image);
                    Box.upload({
                        parentId: obj.objectId,
                        fileURL: uploadFrom.nativePath,
                        success: function () {
                            view.refresh();
                            view.remove(loading);
                        },
                        error: function (evt) {
                            view.remove(loading);
                            alert(evt.error);
                        }
                    });
                }
            });
        };
        actions['Create Folder'] = function () {
            chooseAName(
                'What should it be called?',
                'Create Folder',
                function (name) {
                    Box.createFolder({
                        name: name,
                        parentFolderId: obj.objectId,
                        success: function () {
                            view.refresh();
                            alert('Created new folder!');
                        },
                        error: function (evt) {
                            alert(evt.error);
                        }
                    });
                }
            );
        };
    }
    // Followed by all of the file specific actions
    else {
        actions['Download'] = function () {
            var downloadTo = Ti.Filesystem.getFile(Ti.Filesystem.applicationDataDirectory, obj.objectName);
            Ti.API.info('Downloading ' + downloadTo.nativePath);
            Box.download({
                objectId: obj.objectId,
                fileURL: downloadTo.nativePath,
                success: function () {
                    alert('Downloaded to ' + downloadTo.nativePath);
                },
                error: function (evt) {
                    alert(evt.error);
                }
            });
        };
    }
    // Prevent the user from doing certain actions on the root folder
    if (obj.objectId) {
        actions['Comments'] = function () {
            UI.popIn(getCommentsView(obj));
        };
        actions['Move'] = function () {
            chooseAFolder('Where should we move it?', function (folder) {
                Box.move({
                    objectId: obj.objectId,
                    isFolder: obj.isFolder,
                    destinationFolderId: folder.objectId,
                    success: function () {
                        alert('Moved to ' + folder.objectName + '!');
                    },
                    error: function (evt) {
                        alert(evt.error);
                    }
                });
            });
        };
        actions['Rename'] = function () {
            chooseAName(
                'Rename to what?',
                'Rename ' + (obj.isFolder ? 'Folder' : 'File'),
                function (name) {
                    Box.rename({
                        objectId: obj.objectId,
                        isFolder: obj.isFolder,
                        newName: name,
                        success: function () {
                            view.name.text = name;
                            alert('Renamed!');
                        },
                        error: function (evt) {
                            alert(evt.error);
                        }
                    });
                }
            );
        };
        actions['Remove'] = function () {
            confirm({
                title: 'Confirm Removal',
                message: 'Are you sure?',
                action: 'REMOVE',
                proceed: function () {
                    Box.remove({
                        objectId: obj.objectId,
                        isFolder: obj.isFolder,
                        success: function () {
                            UI.popOut(view);
                            alert('Removed!');
                        },
                        error: function (evt) {
                            alert(evt.error);
                        }
                    });
                }
            });
        };
        actions['Copy'] = function () {
            chooseAFolder('Where should we copy it?', function (folder) {
                Box.copy({
                    objectId: obj.objectId,
                    isFolder: obj.isFolder,
                    destinationFolderId: folder.objectId,
                    success: function () {
                        alert('Copied to ' + folder.objectName + '!');
                    },
                    error: function (evt) {
                        alert(evt.error);
                    }
                });
            });
        };
        actions['Public Share'] = function () {
            chooseSharingOptions('public', { password: true }, function (args) {
                Box.publicShare({
                    objectId: obj.objectId,
                    isFolder: obj.isFolder,
                    emailAddresses: args.emailAddresses.replace(/,/g, ' ').replace(/ +/g, ' ').split(' '),
                    message: args.message,
                    password: args.password,
                    success: function () {
                        alert('Publicly shared ' + (obj.objectName || 'root') + '!');
                    },
                    error: function (evt) {
                        alert(evt.error);
                    }
                });
            });
        };
        actions['Private Share'] = function () {
            chooseSharingOptions('private', { notify: true }, function (args) {
                Box.privateShare({
                    objectId: obj.objectId,
                    isFolder: obj.isFolder,
                    emailAddresses: args.emailAddresses.replace(/,/g, ' ').replace(/ +/g, ' ').split(' '),
                    message: args.message,
                    notifyWhenViewed: args.notifyWhenViewed,
                    success: function () {
                        alert('Privately shared ' + (obj.objectName || 'root') + '!');
                    },
                    error: function (evt) {
                        alert(evt.error);
                    }
                });
            });
        };
        actions['Public Unshare'] = function () {
            Box.publicUnshare({
                objectId: obj.objectId,
                isFolder: obj.isFolder,
                success: function () {
                    alert('Unshared ' + (obj.objectName || 'root') + '!');
                },
                error: function (evt) {
                    alert(evt.error);
                }
            });
        };
    }
    view.actions = actions;

    var container;
    if (Ti.Android) {
        container = Ti.UI.createLabel({
            text: 'Press your device\'s menu button for more options!',
            color: '#000', textAlign: 'left',
            font: { fontSize: 10 + u },
            height: Ti.UI.SIZE || 'auto'
        });
    }
    else {
        container = Ti.UI.createScrollView({
            contentWidth: 'auto',
            layout: 'horizontal'
        });
        for (var key in actions) {
            var button = Ti.UI.createButton({
                title: key,
                left: 5 + u, right: 5 + u,
                height: 25 + u, width: (key.length * 9 + 15) + u
            });
            button.addEventListener('click', actions[key]);
            container.add(button);
        }
    }
    return container;
}

function getDirectoryView(rawFolder) {
    var view = Ti.UI.createView({
        backgroundColor: '#fff'
    });
    var past = {};
    view.refresh = function () {
        var loading = getLoadingView();
        view.add(loading);
        if (past.name) {
            view.remove(past.name);
        }
        if (past.actions) {
            view.remove(past.actions);
        }
        if (past.children) {
            view.remove(past.children);
        }

        var dir = rawFolder == undefined
            ? Box.retrieveFolder()
            : Box.retrieveFolder(rawFolder.objectId);

        if (dir.error) {
            view.add(Ti.UI.createLabel({
                text: dir.error, textAlign: 'center',
                color: '#000'
            }));
            return;
        }

        // Show the name
        var name = past.name = view.name = Ti.UI.createLabel({
            text: (dir.objectName || 'Root') + ': ' + dir.fileCount + ' file(s), ' + dir.folderCount + ' folder(s)',
            top: 10 + u, left: 30 + u, right: 30 + u,
            color: '#000', textAlign: 'left',
            height: 25 + u
        });
        view.add(name);

        // Show all the changes we can make to this folder.
        var actions = past.actions = getActionsView(dir, view);
        actions.top = 35 + u;
        actions.height = 25 + u;
        view.add(actions);

        // List all of the children of this folder in a table view.
        var data = [];
        for (var i = 0, l = dir.objectsInFolder.length; i < l; i++) {
            var current = dir.objectsInFolder[i];
            data.push(getRow({
                title: current.objectName + (current.isFolder ? '/' : ''),
                color: '#000'
            }));
        }
        var children = past.children = Ti.UI.createTableView({
            top: 70 + u, bottom: 0,
            data: data
        });
        children.addEventListener('click', function (evt) {
            var obj = dir.objectsInFolder[evt.index];
            var loading = getLoadingView();
            loading.right = 10 + u;
            evt.row.add(loading);
            var childView = (obj.isFolder ? getDirectoryView : getFileView)(obj);
            childView.addEventListener('open', function () {
                loading.hide();
            });
            childView.addEventListener('close', function () {
                view.refresh();
            });
            UI.popIn(childView);
        });
        view.add(children);
        
        view.remove(loading);
    };
    view.refresh();
    return view;
}

function getFileView(file) {
    var view = Ti.UI.createView({
        backgroundColor: '#fff'
    });

    // Show the name
    view.add(view.name = Ti.UI.createLabel({
        text: file.objectName,
        top: 10 + u, left: 30 + u, right: 30 + u,
        color: '#000', textAlign: 'left',
        height: 25 + u
    }));

    // Show all the changes we can make to this file
    var actions = getActionsView(file, view);
    actions.top = 35 + u;
    actions.height = 25 + u;
    view.add(actions);

    // Show the thumbnails for this file
    view.add(Ti.UI.createScrollableView({
        top: 70 + u,
        pagingControlHeight: 40 + u,
        views: [
            Ti.UI.createImageView({ image: file.smallThumbnailURL }),
            Ti.UI.createImageView({ image: file.largeThumbnailURL }),
            Ti.UI.createImageView({ image: file.largerThumbnailURL }),
            Ti.UI.createImageView({ image: file.previewThumbnailURL })
        ]
    }));

    return view;
}

function getCommentsView(obj) {
    var view = Ti.UI.createView({
        backgroundColor: '#fff'
    });

    // Show the name
    view.add(view.name = Ti.UI.createLabel({
        text: 'Comments for ' + (obj.objectName || 'Root'),
        top: 10 + u, left: 30 + u, right: 30 + u,
        color: '#000', textAlign: 'left',
        height: 25 + u
    }));

    // Let them add comments
    var newComment = Ti.UI.createTextField({
        hintText: '',
        top: 35 + u, left: 10 + u, right: 10 + u,
        height: 40 + u,
        borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED
    });
    newComment.addEventListener('return', function () {
        if (newComment.value.length > 0) {
            view.add(loading);
            Box.addComment({
                objectId: obj.objectId,
                isFolder: obj.isFolder,
                message: newComment.value,
                success: function () {
                    view.refresh();
                    newComment.value = '';
                },
                error: function (evt) {
                    view.remove(loading);
                    alert(evt.error);
                }
            });
        }
    });
    view.add(newComment);

    var table = Ti.UI.createTableView({
        top: 80 + u
    });
    table.addEventListener('click', function (evt) {
        if (evt.row) {
            confirm({
                title: 'Confirm Remove Comment',
                message: 'Are you sure?',
                action: 'REMOVE',
                proceed: function () {
                    view.add(loading);
                    Box.deleteComment({
                        commentId: evt.row.commentId,
                        success: function () {
                            view.refresh();
                            view.remove(loading);
                            alert('Comment removed!');
                        },
                        error: function (evt) {
                            view.remove(loading);
                            alert(evt.error);
                        }
                    });
                }
            });
        }
    });
    view.add(table);

    var loading = getLoadingView();
    view.add(loading);

    view.refresh = function () {
        Box.getComments({
            objectId: obj.objectId,
            isFolder: obj.isFolder,
            success: function (evt) {
                var comments = evt.comments;
                var rows = [];
                for (var i = 0; i < comments.length; i++) {
                    rows.push(getRow({
                        commentId: comments[i].commentId,
                        title: comments[i].userName + ': ' + comments[i].message,
                        leftImage: comments[i].avatarURL,
                        color: '#000'
                    }));
                }
                table.setData(rows);
                view.remove(loading);
            },
            error: function (evt) {
                view.remove(loading);
                alert(evt.error);
            }
        });
    };

    setTimeout(view.refresh, 500);

    return view;
}

function getUpdatesView() {
    var view = Ti.UI.createView({
        backgroundColor: '#fff'
    });

    // Show the name
    view.add(view.name = Ti.UI.createLabel({
        text: '7 Days of Updates',
        top: 10 + u, left: 30 + u, right: 30 + u,
        color: '#000', textAlign: 'left',
        height: 25 + u
    }));

    var table = Ti.UI.createTableView({
        top: 40 + u
    });
    table.addEventListener('click', function (evt) {
        UI.popIn(getUpdateView(evt.row.update));
    });
    view.add(table);

    var loading = getLoadingView();
    view.add(loading);

    var sinceTime = new Date();
    sinceTime.setDate(sinceTime.getDate() - 7);

    view.refresh = function () {
        Box.getUpdates({
            sinceTime: sinceTime,
            success: function (evt) {
                var updates = evt.updates;
                var rows = [];
                for (var i = 0; i < updates.length; i++) {
                    rows.push(getRow({
                        title: updates[i].update + ' '
                            + updates[i].folders.length + ' dirs, and '
                            + updates[i].files.length + ' files',
                        color: '#000',
                        update: updates[i]
                    }));
                }
                table.setData(rows);
                view.remove(loading);
            },
            error: function (evt) {
                view.remove(loading);
                alert(evt.error);
            }
        });
    };

    setTimeout(view.refresh, 500);

    return view;
}

function getUpdateView(update) {
    var view = Ti.UI.createView({
        backgroundColor: '#fff'
    });

    view.add(Ti.UI.createLabel({
        text: 'Update Details',
        top: 10 + u, left: 10 + u, right: 10 + u,
        height: 40 + u,
        color: 'black'
    }));

    var data = [
        getRow({ title: 'updateId: ' + update.updateId, color: '#000' }),
        getRow({ title: 'userId: ' + update.userId, color: '#000' }),
        getRow({ title: 'userName: ' + update.userName, color: '#000' }),
        getRow({ title: 'userEmail: ' + update.userEmail, color: '#000' }),
        getRow({ title: 'updateUpdatedTime: ' + update.updateUpdatedTime, color: '#000' }),
        getRow({ title: 'folderId: ' + update.folderId, color: '#000' }),
        getRow({ title: 'folderName: ' + update.folderName, color: '#000' }),
        getRow({ title: 'isShared: ' + update.isShared, color: '#000' }),
        getRow({ title: 'shareName: ' + update.shareName, color: '#000' }),
        getRow({ title: 'ownerId: ' + update.ownerId, color: '#000' }),
        getRow({ title: 'collabAccess: ' + update.collabAccess, color: '#000' }),
        getRow({ title: 'updateType: ' + update.updateType, color: '#000' }),
        getRow({ title: 'update: ' + update.update, color: '#000' })
    ];

    data.push({ title: 'Files: ' + update.files.length });
    for (var i = 0; i < update.files.length; i++) {
        data.push(getRow({ title: i + ' - ' + update.files[i].objectName, isFolder: false, arrayIndex: i }));
    }

    data.push({ title: 'Folders: ' + update.folders.length });
    for (var j = 0; j < update.folders.length; j++) {
        data.push(getRow({ title: j + ' - ' + update.folders[j].objectName, isFolder: true, arrayIndex: j }));
    }

    var table = Ti.UI.createTableView({
        top: 50 + u,
        data: data
    });
    table.addEventListener('click', function (evt) {
        var obj = evt.row.isFolder ? update.folders[evt.row.arrayIndex] : update.files[evt.row.arrayIndex];
        if (!obj)
            return;
        var loading = getLoadingView();
        loading.right = 10 + u;
        evt.row.add(loading);
        var childView = (obj.isFolder ? getDirectoryView : getFileView)(obj);
        childView.addEventListener('open', function () {
            loading.hide();
        });
        UI.popIn(childView);
    });
    view.add(table);

    return view;
}

function chooseAFolder(message, success) {
    var view = Ti.UI.createView({
        backgroundColor: '#fff',
        top: 20 + u, right: 20 + u, bottom: 20 + u, left: 20 + u,
        borderColor: '#000', borderWidth: 2,
        zIndex: UI.zIndexLevels.dialog
    });

    view.add(Ti.UI.createLabel({
        text: message,
        top: 10 + u, left: 10 + u, right: 10 + u,
        height: 40 + u,
        color: 'black'
    }));

    function createListForFolder(rawFolder, parentChildren) {
        var dir = rawFolder == undefined
            ? Box.retrieveFolder()
            : Box.retrieveFolder(rawFolder.objectId);

        if (dir.error) {
            alert(dir.error);
            return;
        }

        // List all of the children folders of this folder in a table view.
        var data = [
            getRow({ title: '../', obj: null }),
            getRow({ title: 'Use This Folder', obj: rawFolder })
        ];
        for (var i = 0, l = dir.objectsInFolder.length; i < l; i++) {
            var current = dir.objectsInFolder[i];
            // Only add it to the list if it is a folder.
            if (current.isFolder) {
                data.push(getRow({
                    title: current.objectName + (current.isFolder ? '/' : ''),
                    color: '#000'
                }));
            }
        }
        var children = Ti.UI.createTableView({
            top: 40 + u, bottom: 0 + u,
            data: data,
            backgroundColor: 'white'
        });
        children.addEventListener('click', function (evt) {
            var loading = getLoadingView();
            loading.right = 10 + u;
            evt.row.add(loading);
            if (evt.row) {
                if (evt.row.title == '../') {
                    if (rawFolder == undefined) {
                        UI.popOut(view);
                    }
                    else {
                        view.remove(children);
                        if (parentChildren) {
                            view.add(parentChildren);
                        }
                    }
                }
                else if (evt.row.title == 'Use This Folder') {
                    UI.popOut(view);
                    success(dir);
                }
                // Otherwise, they clicked in to a new folder.
                else {
                    createListForFolder(dir.objectsInFolder[evt.index], children);
                }
            }
            loading.hide();
        });
        if (parentChildren) {
            view.remove(parentChildren);
        }
        view.add(children);
    }

    createListForFolder();

    UI.popIn(view);
}

function chooseAName(message, action, success) {
    var view = Ti.UI.createView({
        backgroundColor: '#fff',
        top: 20 + u, right: 20 + u, bottom: 20 + u, left: 20 + u,
        borderColor: '#000', borderWidth: 2,
        zIndex: UI.zIndexLevels.dialog
    });

    view.add(Ti.UI.createLabel({
        text: message,
        top: 10 + u, left: 10 + u, right: 10 + u,
        height: 40 + u,
        color: 'black'
    }));


    var text = Ti.UI.createTextField({
        hintText: '',
        top: 50 + u, left: 10 + u, right: 10 + u,
        height: 40 + u,
        borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED
    });
    view.add(text);

    var button = Ti.UI.createButton({
        title: action,
        top: 100 + u, left: 10 + u, right: 10 + u,
        height: 40 + u
    });
    view.add(button);

    function submitForm() {
        if (!text.value.length) {
            text.focus();
            return;
        }
        text.blur();
        UI.popOut(view);
        success(text.value);
    }

    button.addEventListener('click', submitForm);
    text.addEventListener('return', submitForm);

    view.addEventListener('open', function () {
        text.focus();
    });

    UI.popIn(view);
}

function chooseSharingOptions(type, showOptions, success) {
    var view = Ti.UI.createView({
        backgroundColor: '#fff',
        top: 20 + u, right: 20 + u, bottom: 20 + u, left: 20 + u,
        borderColor: '#000', borderWidth: 2,
        zIndex: UI.zIndexLevels.dialog
    });
    var content = Ti.UI.createScrollView({
        contentHeight: 'auto',
        layout: 'vertical'
    });
    view.add(content);

    content.add(Ti.UI.createLabel({
        text: 'Choose your ' + type + ' sharing options',
        top: 10 + u, left: 10 + u, right: 10 + u,
        height: 40 + u,
        color: 'black'
    }));

    var fields = {};

    var emailAddresses = Ti.UI.createTextField({
        hintText: 'Email Addresses',
        top: 10 + u, left: 10 + u, right: 10 + u,
        height: 40 + u,
        borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED
    });
    content.add(fields.emailAddresses = emailAddresses);

    if (showOptions.password) {
        var password = Ti.UI.createTextField({
            hintText: 'Password (optional)',
            top: 10 + u, left: 10 + u, right: 10 + u,
            isOptional: true,
            height: 40 + u,
            borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED
        });
        content.add(fields.password = password);
    }

    var message = Ti.UI.createTextField({
        hintText: 'Message',
        top: 10 + u, left: 10 + u, right: 10 + u,
        height: 40 + u,
        borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED
    });
    content.add(fields.message = message);

    if (showOptions.notify) {
        var label = Ti.UI.createLabel({
            text: 'Notify When Viewed:', textAlign: 'left',
            color: 'black',
            top: 10 + u, left: 10 + u, right: 10 + u,
            height: 40 + u
        });
        content.add(label);
        var notifyWhenViewed = Ti.UI.createSwitch({
            value: false, isSwitch: true,
            top: 10 + u, right: 10 + u,
            height: 40 + u
        });
        content.add(fields.notifyWhenViewed = notifyWhenViewed);
    }

    var button = Ti.UI.createButton({
        title: 'Share',
        top: 10 + u, left: 10 + u, right: 10 + u,
        height: 40 + u
    });
    content.add(button);

    function submitForm() {
        var result = {};
        for (var key in fields) {
            if (!fields[key].isSwitch && !fields[key].isOptional && !fields[key].value.length) {
                fields[key].focus();
                return;
            }
            result[key] = fields[key].value;
            if (!fields[key].isSwitch) {
                fields[key].blur();
            }
        }
        UI.popOut(view);
        success(result);
    }

    button.addEventListener('click', submitForm);
    for (var key in fields) {
        fields[key].addEventListener('return', submitForm);
    }

    view.addEventListener('open', function () {
        emailAddresses.focus();
    });

    UI.popIn(view);
}

function bytesToStringSize(bytes) {
    if (!bytes)
        return '0 bytes';
    var s = ['bytes', 'kb', 'MB', 'GB', 'TB', 'PB'];
    var e = Math.floor(Math.log(bytes) / Math.log(1024));
    return (bytes / Math.pow(1024, Math.floor(e))).toFixed(2) + ' ' + s[e];
}