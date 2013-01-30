package ti.map;

import java.util.ArrayList;
import java.util.HashMap;

import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.AsyncResult;
import org.appcelerator.kroll.common.TiMessenger;
import org.appcelerator.titanium.TiC;
import org.appcelerator.titanium.TiContext;
import org.appcelerator.titanium.util.TiConvert;

import android.os.Message;

import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.gms.maps.model.PolylineOptions;

@Kroll.proxy(creatableInModule=MapModule.class, propertyAccessors = {
	"points",
	TiC.PROPERTY_COLOR,
	TiC.PROPERTY_WIDTH
})
public class RouteProxy extends KrollProxy{
	
	private PolylineOptions options;
	private Polyline route;
	
	private static final String POINTS = "points";
	
	private static final int MSG_FIRST_ID = KrollProxy.MSG_LAST_ID + 1;
	
	private static final int MSG_SET_POINTS = MSG_FIRST_ID + 400;
	private static final int MSG_SET_COLOR = MSG_FIRST_ID + 401;
	private static final int MSG_SET_WIDTH = MSG_FIRST_ID + 402;

	public RouteProxy() {
		super();
	}
	
	public RouteProxy(TiContext tiContext) {
		this();
	}
	
	public boolean handleMessage(Message msg) 
	{
		AsyncResult result = null;
		switch (msg.what) {

		case MSG_SET_POINTS: {
			result = (AsyncResult) msg.obj;
			route.setPoints(processPoints(result.getArg(), true));
			result.setResult(null);
			return true;
		}
		
		case MSG_SET_COLOR: {
			result = (AsyncResult) msg.obj;
			route.setColor((Integer)result.getArg());
			result.setResult(null);
			return true;
		}
		
		case MSG_SET_WIDTH: {
			result = (AsyncResult) msg.obj;
			route.setWidth((Float)result.getArg());
			result.setResult(null);
			return true;
		}
		default : {
			return super.handleMessage(msg);
		}
		}
	}
	public void processOptions() {

		options = new PolylineOptions();

		if (hasProperty(POINTS)) {
			 processPoints(getProperty(POINTS), false);
		}
		
		if (hasProperty(TiC.PROPERTY_WIDTH)) {
			options.width(TiConvert.toFloat(getProperty(TiC.PROPERTY_WIDTH)));
		}
		
		if (hasProperty(TiC.PROPERTY_COLOR)) {
			options.color(TiConvert.toColor((String)getProperty(TiC.PROPERTY_COLOR)));
		}
		
	}

	public ArrayList<LatLng> processPoints(Object points, boolean list) {
		
		ArrayList<LatLng> locationArray = new ArrayList<LatLng>();
		//multiple points
		if (points instanceof Object[]) {
			Object[] pointsArray = (Object[]) points;
			for (int i = 0; i < pointsArray.length; i++) {
				Object obj = pointsArray[i];
				if (obj instanceof HashMap<?, ?>) {
					HashMap<String, String> point = (HashMap<String, String>) obj;
					LatLng location = new LatLng(TiConvert.toDouble(point.get("latitude")), TiConvert.toDouble(point.get("longitude")));
					if (list) {
						locationArray.add(location);
					} else {
						options.add(location);
					}
				}
			}
		}
		//single point
		if (points instanceof HashMap) {
			HashMap<String, String> point = (HashMap<String, String>) points;
			LatLng location = new LatLng(TiConvert.toDouble(point.get("latitude")), TiConvert.toDouble(point.get("longitude")));
			if (list) {
				locationArray.add(location);
			} else {
				options.add(location);
			}
		}
		return locationArray;
	}
	
	public PolylineOptions getOptions() {
		return options;
	}
	
	public void setRoute(Polyline r) {
		route = r;
	}
	
	public Polyline getRoute() {
		return route;
	}
	
	public void onPropertyChanged(String name, Object value) {
		super.onPropertyChanged(name, value);
		if (route == null) {
			return;
		}
		
		if (name.equals(POINTS)) {
			TiMessenger.sendBlockingMainMessage(getMainHandler().obtainMessage(MSG_SET_POINTS), value);
		}

		if (name.equals(TiC.PROPERTY_COLOR)) {
			TiMessenger.sendBlockingMainMessage(getMainHandler().obtainMessage(MSG_SET_COLOR), TiConvert.toColor((String)value));
		}
		
		if (name.equals(TiC.PROPERTY_WIDTH)) {
			TiMessenger.sendBlockingMainMessage(getMainHandler().obtainMessage(MSG_SET_WIDTH), TiConvert.toFloat(value));
		}
		
	}
	
}