var Columns = require('ti.columns');



function MainWindow() {
	var textAlignButton = Ti.UI.createButton({
		title: 'textAlign change'
	});

	var win = Ti.UI.createWindow({
		orientationModes: [
		Titanium.UI.PORTRAIT, Titanium.UI.UPSIDE_PORTRAIT, Titanium.UI.LANDSCAPE_LEFT, Titanium.UI.LANDSCAPE_RIGHT],
		leftNavButton: textAlignButton,
		tabBarHidden: true
	});
	var Lorem = '\tLorem ipsum dolor sit amet, consectetur adipiscing elit. Integer in aliquet justo. Nullam vel metus turpis, ut tincidunt metus. Pellentesque sollicitudin, lorem at hendrerit vehicula, ligula diam laoreet orci, vel blandit ante nisi vel risus. Curabitur a dolor nisl, pretium congue erat. Nunc malesuada, lacus quis pellentesque placerat, risus massa vulputate tortor, ac mattis diam mauris vitae lacus. Phasellus gravida, velit id imperdiet euismod, nisi magna gravida ipsum, in dapibus massa arcu non est. Nullam ac nulla sem. Donec quis elit eget odio imperdiet laoreet. Donec cursus interdum lectus eget fermentum. Donec volutpat accumsan augue a vulputate. Nam porttitor, elit id auctor dignissim, nunc nunc venenatis erat, sed tincidunt ipsum dolor vitae arcu.' + '\n\tAenean eleifend eleifend magna, ultricies pellentesque felis fermentum non. Aliquam erat volutpat. Suspendisse in tortor dui, rhoncus lobortis nulla. Curabitur cursus dapibus ipsum eu vehicula. In id eros id libero mattis dignissim sed nec justo. Nam euismod elementum arcu non sodales. Duis eget lectus dui. Donec non magna risus. Donec condimentum augue a lacus sollicitudin sit amet ullamcorper ante aliquet. Pellentesque ipsum urna, pharetra et fermentum tincidunt, facilisis eget tortor. Donec et mi sed dui facilisis consectetur. Vestibulum sit amet elit leo. Quisque erat dui, tempus eu iaculis sit amet, condimentum sollicitudin elit. Fusce vehicula suscipit gravida. Phasellus massa libero, congue tempus suscipit ac, luctus vel ipsum.' + '\n\tCurabitur eleifend, libero in auctor auctor, erat odio congue mi, non facilisis dolor justo id lacus. Integer sem risus, volutpat non varius in, dapibus et lacus. Suspendisse lacinia pretium fermentum. Phasellus erat purus, tempus ut faucibus ac, mattis molestie turpis. Duis augue diam, aliquet nec porta eget, vehicula vel risus. Aliquam vehicula risus in odio mattis sed pretium lectus venenatis. Suspendisse nec convallis ante. Cras quis mauris eu eros euismod vestibulum quis ut enim. Aliquam sollicitudin aliquet imperdiet. Curabitur lacinia rutrum massa ac lobortis. Morbi vitae pulvinar nunc. Mauris adipiscing nunc nec odio ultrices volutpat. Sed mi massa, viverra vehicula ornare iaculis, rutrum vitae massa. Pellentesque mauris eros, auctor ut posuere sed, suscipit quis augue. Proin commodo aliquet risus sit amet ullamcorper.' + '\n\tDonec quam lectus, porta at pellentesque sit amet, pharetra vel sem. Cras orci dolor, adipiscing vel commodo vel, cursus sit amet purus. Aliquam elementum vulputate pretium. Quisque bibendum sollicitudin velit et tincidunt. Pellentesque semper consectetur turpis, vitae vestibulum risus ultrices cursus. Nam id tellus diam, a consectetur diam. Praesent nibh lorem, rhoncus eget pellentesque a, molestie eu nisi. Curabitur sollicitudin dolor consectetur justo venenatis tempor. Vestibulum est sapien, dignissim ut sagittis at, lobortis eu risus. Aenean sit amet lorem ac ipsum porttitor rutrum vel dapibus lorem. Donec facilisis, velit sit amet viverra tincidunt, mauris quam venenatis dolor, vitae mollis urna odio ac nisl.' + '\n\tNam vitae nisl vitae dolor gravida dignissim. Nunc sagittis, arcu in luctus aliquet, libero nulla interdum magna, ut elementum ipsum erat vitae nulla. Suspendisse lobortis dignissim dui, vitae varius eros porta ac. Nulla congue dictum pulvinar. Integer mollis consequat nulla ac feugiat. Morbi fringilla, augue sit amet porttitor posuere, felis felis iaculis nulla, in tempus arcu ante eget ipsum. Fusce hendrerit nisi in orci condimentum quis consectetur risus luctus. Praesent pellentesque, nisl vitae sagittis malesuada, massa erat porttitor magna, ac consectetur risus justo imperdiet enim. Nulla sagittis dignissim purus, et suscipit libero ultricies eget.' + '\n\tPhasellus tristique tempor ullamcorper. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Maecenas nunc quam, porta non dignissim eu, viverra in elit. Nunc ultricies cursus erat nec posuere. Nullam nisl tellus, consequat sit amet venenatis non, congue eu justo. Nulla pharetra nisi ut nisl tincidunt ut posuere risus faucibus. Nunc blandit semper odio condimentum posuere. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae.' + '\n\tCras accumsan dapibus arcu id iaculis. Etiam sapien nisl, tincidunt eget dapibus vitae, mattis a quam. Pellentesque consequat aliquet risus ac varius. Duis ultrices, magna eu dapibus accumsan, leo purus ornare odio, nec ullamcorper sem mi quis nulla. Nulla id turpis nulla, vel malesuada justo. Phasellus nibh nisi, vestibulum in fringilla et, egestas at tellus. Suspendisse at turpis odio. Phasellus facilisis molestie purus quis porttitor. Mauris ullamcorper mattis auctor. Sed iaculis cursus mauris, at tempus velit laoreet id. Donec condimentum luctus venenatis. Aenean ut faucibus mauris. Fusce lectus neque, faucibus non laoreet eu, venenatis at arcu. Nullam convallis euismod tortor, sed dictum risus dignissim sit amet. Ut sed quam ante.' + '\n\tMaecenas eros velit, fermentum at tempor sit amet, placerat in eros. Praesent pulvinar auctor dui, eu commodo lorem volutpat ac. Nulla non turpis elit. Ut iaculis luctus dignissim. Vestibulum pharetra nisl turpis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Maecenas ac libero nisi. Praesent ligula eros, sodales ac iaculis at, porttitor quis sapien. Curabitur vel sapien a neque viverra lacinia. Mauris adipiscing molestie tortor, consequat semper neque pellentesque vel. Nam metus lacus, vestibulum in volutpat sit amet, cursus et eros.' + '\n\tCurabitur sit amet condimentum erat. Quisque dapibus mollis laoreet. Etiam ut felis ac elit dictum placerat. Praesent ac feugiat orci. Pellentesque facilisis tincidunt nisi vel auctor. Aliquam vestibulum mi eu diam pulvinar dignissim. Donec elit metus, iaculis non porta quis, placerat ut enim. Maecenas ut lectus justo. Vivamus magna ligula, laoreet in adipiscing sit amet, malesuada sit amet augue. Phasellus lectus sapien, lobortis vel rhoncus et, volutpat sit amet metus. Pellentesque est justo, pulvinar id eleifend in, lacinia id metus. Quisque ac mi quis nunc suscipit lacinia. Pellentesque eleifend risus et est iaculis tincidunt. Nulla ut turpis in quam rhoncus fermentum. Donec lorem nisl, dapibus sit amet condimentum sit amet, cursus ac elit.' + '\n\tInteger nisi mi, adipiscing at accumsan quis, aliquet sed nisl. Vestibulum suscipit leo tortor. Quisque nec lorem quis purus imperdiet lobortis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec ac risus non nibh congue dapibus. Sed nec est lectus. Pellentesque non nibh at lacus varius pretium.' + '\n\tCurabitur non nulla non leo consequat egestas quis eget nunc. Nunc id mollis orci. Integer vestibulum tellus et tortor varius interdum. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Morbi eu dui sed urna molestie venenatis eu nec purus. Curabitur laoreet, elit eu blandit suscipit, magna metus ultricies nisi, vel vulputate felis nibh vel mi. Pellentesque turpis purus, varius adipiscing rutrum sit amet, malesuada et arcu. Suspendisse tincidunt sollicitudin lacus nec sagittis. Suspendisse et est vel sem volutpat facilisis eget non ante. Suspendisse lacus orci, sodales et interdum eget, tristique tincidunt felis. Suspendisse varius, lorem sed luctus aliquam, diam orci volutpat ante, vitae tristique erat erat accumsan arcu.' + '\n\tEtiam vitae enim sed neque scelerisque sollicitudin vel dignissim velit. Nunc ut magna semper dui ultrices dictum. Integer volutpat lacus in lacus pharetra iaculis. Proin arcu ante, condimentum quis adipiscing quis, bibendum nec risus. Donec eu nisi id enim ultrices porttitor. Ut sodales elit nec quam cursus vitae tristique lacus dignissim. Nam vestibulum, dolor in varius tincidunt, lacus nisi condimentum lacus, in scelerisque augue odio bibendum est. Nullam non est risus, in gravida purus. Etiam nisi nunc, feugiat in vestibulum nec, vestibulum sit amet lorem. Integer tempus, risus rutrum viverra accumsan, sapien tortor consectetur tellus, eget tincidunt ligula dolor ac eros. Suspendisse justo leo, rhoncus vitae faucibus et, laoreet id dolor. Praesent vitae velit justo. Aenean vitae nunc congue massa malesuada dictum eu eu tellus. Donec id erat et dui adipiscing hendrerit et nec tortor.' + '\n\tNulla nulla metus, vulputate vitae volutpat ut, tincidunt vel metus. Nam nec odio tellus, vitae hendrerit sem. Donec eget ligula quis dui consequat tincidunt scelerisque ac diam. Fusce mi urna, condimentum vel rhoncus sit amet, interdum et arcu. Aliquam erat volutpat. Sed mollis molestie justo vitae tempus. Suspendisse potenti. Nullam adipiscing eros eu mauris pharetra iaculis. Vestibulum vitae metus nisi. Ut ultricies rutrum eros, sit amet mattis arcu adipiscing nec.' + '\n\tNam placerat fermentum libero in hendrerit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. In hac habitasse platea dictumst. In in lacus tristique nibh laoreet ultrices nec vitae magna. Proin et lacinia lorem. Curabitur sit amet tempus metus. Duis varius mollis tempor. Proin neque risus, pharetra vel imperdiet at, vulputate at dui. Etiam imperdiet viverra sapien adipiscing molestie. Vivamus nec dui augue. Integer blandit lobortis ipsum vel sagittis.' + '\n\tPraesent sem erat, placerat vel iaculis vel, condimentum at libero. Ut iaculis, nunc vitae euismod vulputate, nisi nisl volutpat velit, sed dapibus leo libero id dui. Mauris bibendum imperdiet laoreet. Integer ut ante et nulla vehicula auctor eu vel lectus. Pellentesque sollicitudin pretium fringilla. Donec sollicitudin tincidunt arcu venenatis iaculis. Nullam placerat metus quis eros pulvinar at lobortis purus consequat.';

	var columns = Columns.createTextView({
		text: Lorem,
		// make it longer 
		portraitColumns: 2,
		landscapeColumns: 3,
		minFontSize: 9,
		maxFontSize: 30,
		font: {
			fontSize: 12,
			fontFamily: 'arial'
		}
	});

	win.add(columns);

	var scrollTo = Ti.UI.createButton({
		title: 'scrollTo #3'
	});

	win.setRightNavButton(scrollTo);

	scrollTo.addEventListener('click', function() {
		columns.scrollToPage(2, {
			animated: true
		});
	});

	var x = 1;
	textAlignButton.addEventListener('click', function() {
		switch (x) {
			case 0:	columns.textAlign = 'left'; x++; break;
			case 1: columns.textAlign = 'right'; x++; break;
			case 2: columns.textAlign = 'center'; x++; break;
			case 3: columns.textAlign = 'justify'; x++; break;
			case 4: columns.textAlign = 'natural'; x = 0; break;
		}
	});

	columns.addEventListener('scroll', function(e) {
		// fired when we scoll
		Ti.API.info(e);
	});

	function handleOrientation(){
		// scroll to current page
		columns.setCurrentPage(columns.currentPage);
	}
	
	win.addEventListener('close', function(){
		Ti.Gesture.removeEventListener('orientationchange', handleOrientation);
	});
	Ti.Gesture.addEventListener('orientationchange', handleOrientation);

	return {
		window: win
	}
}
var tabGroup = Ti.UI.createTabGroup();

var tab1 = Ti.UI.createTab({
	window: MainWindow().window
});

tabGroup.addTab(tab1);

tabGroup.open();
