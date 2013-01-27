package ti.map;

import java.lang.ref.WeakReference;

import com.google.android.gms.maps.model.Marker;

public class TiMarker {
	private Marker marker;
	private WeakReference<AnnotationProxy> proxy;
	
	public TiMarker(Marker m, AnnotationProxy p) {
		marker = m;
		proxy = new WeakReference<AnnotationProxy>(p);
	}
	
	public void setMarker(Marker m) {
		marker = m;
	}
	public Marker getMarker() {
		return marker;
	}
	
	public AnnotationProxy getProxy() {
		return proxy.get();
	}
}
