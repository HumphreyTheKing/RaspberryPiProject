const apiKey = "AIzaSyB5GVqZRteRz2N6TwIZ20H3emFxHAOcRaw";

(g=>{var h,a,k,p="The Google Maps JavaScript API",c="google",l="importLibrary",q="__ib__",m=document,b=window;b=b[c]||(b[c]={});var d=b.maps||(b.maps={}),r=new Set,e=new URLSearchParams,u=()=>h||(h=new Promise(async(f,n)=>{await (a=m.createElement("script"));e.set("libraries",[...r]+"");for(k in g)e.set(k.replace(/[A-Z]/g,t=>"_"+t[0].toLowerCase()),g[k]);e.set("callback",c+".maps."+q);a.src=`https://maps.${c}apis.com/maps/api/js?`+e;d[q]=f;a.onerror=()=>h=n(Error(p+" could not load."));a.nonce=m.querySelector("script[nonce]")?.nonce||"";m.head.append(a)}));d[l]?console.warn(p+" only loads once. Ignoring:",g):d[l]=(f,...n)=>r.add(f)&&u().then(()=>d[l](f,...n))})({
    key: apiKey,
    v: "weekly",
  });

let map;

async function getMap() {
    // Position center of map when loading webpage
    const position = { lat: 36.1077863, lng: -115.1453609 };

    const { Map } = await google.maps.importLibrary("maps");
    const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

    map = new Map(document.getElementsByClassName("map")[0], {
        zoom: 15.7,
        center: position,
        mapId: 'deb598f8aa025a7f', // ID links to my customized map
    });

    // All map markers & coordinates
    const markers = [
        { position: { lat: 36.1112, lng: -115.1401 }, title: "Cottage Grove Parking Garage"},
        { position: { lat: 36.103, lng: -115.1431 }, title: "Tropicana Parking Garage"}
    ];

    // Place each marker on the map
    markers.forEach(marker => {
        new AdvancedMarkerElement({
            position: marker.position,
            map: map,
            title: marker.title
        });
    });

}

getMap();