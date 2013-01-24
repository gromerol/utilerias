/**
 * In this example, you'll learn how to use the PayPal module.
 *
 * There are four different types of payments you can do:
 * - Simple Payments
 * - Parallel Payments
 * - Chain Payments
 * - and Preapprovals
 *
 * We'll demonstrate each of these in their own tab.
 */
var tabGroup = Ti.UI.createTabGroup();

tabGroup.addTab(Ti.UI.createTab({
    title: 'Preapproval',
    window: Ti.UI.createWindow({
        title: 'Preapproval',
        url: 'preapproval.js',
        backgroundColor: '#fff'
    })
}));
tabGroup.addTab(Ti.UI.createTab({
    title: 'Simple',
    window: Ti.UI.createWindow({
        title: 'Simple',
        url: 'simple.js',
        backgroundColor: '#fff'
    })
}));
tabGroup.addTab(Ti.UI.createTab({
    title: 'Parallel',
    window: Ti.UI.createWindow({
        title: 'Parallel',
        url: 'parallel.js',
        backgroundColor: '#fff'
    })
}));
tabGroup.addTab(Ti.UI.createTab({
    title: 'Chain',
    window: Ti.UI.createWindow({
        title: 'Chain',
        url: 'chain.js',
        backgroundColor: '#fff'
    })
}));

tabGroup.open();