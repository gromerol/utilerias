var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
win.open();

var b1 = Ti.UI.createButton({
	title:'POSITIVE',
	top:10,
	left:10
})

var b2 = Ti.UI.createButton({
	title:'NEGATIVE',
	top:10,
	right:10
})

var label = Ti.UI.createLabel({
	height:'50%'
})

win.add(b1);
win.add(b2);
win.add(label);

if (Ti.Platform.osname == 'android')
{
	var Ntlm = require('ti.ntlm');
}

var client = null;

var initClient = function()
{
	client = null;
	client = Ti.Network.createHTTPClient({
		// function called when the response data is available
    	onload : function(e) {
    		label.text = 'SUCCESS \n\n'+client.responseText;
    	},
   		// function called when an error occurs, including a timeout
   		onerror : function(e) {
    	   	label.text = 'ERROR';
   		},
   		timeout : 5000  // in milliseconds
	});
	
	if (Ti.Platform.osname == 'android')
	{
		Ti.API.info(Ntlm.getAuthScheme());
		client.addAuthFactory(Ntlm.getAuthScheme(),Ntlm.getAuthFactory());
	}
}

b1.addEventListener('click',function(){
	initClient();
	var url = "<<YOUR SERVER URL>>";
	client.username='<<USERNAME>>';
	client.password='<<PASSWORD>>';
	client.domain='<<DOMAIN>>'
 	client.open("GET", url);
 	client.send();
});

b2.addEventListener('click',function(){
	initClient();
	var url = "<<YOUR SERVER URL>>";
	client.username='<<USERNAME>>';
	client.password='badpass';
	client.domain='<<DOMAIN>>'
 	client.open("GET", url);
 	client.send();
});