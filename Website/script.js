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
        { position: { lat: 36.1112, lng: -115.1401 }, title: "Cottage Grove Parking Garage", address:"1067 Cottage Grove Ave, Las Vegas, NV 89119"},
        { position: { lat: 36.103, lng: -115.1431 }, title: "Tropicana Parking Garage", address: "12 Wilbur St, Las Vegas, NV 89119"},
        { position: { lat: 36.10342, lng: -115.136193 }, title: "University Gateway Parking Garage", address: "1280 Dorothy Ave, Las Vegas, NV 89119"}
    ];

    let info;

    // Place each marker on the map
    markers.forEach(marker => {
        const mark = new AdvancedMarkerElement({
            position: marker.position,
            map: map,
            title: marker.title,
        });

        // Add mark title on hover 
        mark.element.tile = marker.title;        
        // Cursor style on marker hover
        mark.element.style.cursor = "pointer";
        

        // Adjustments for marker click
        mark.addListener("click", () => {
            const googleMapsLink = `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(marker.address)}`;

            if(info){
                info.close();
            }
            info = new google.maps.InfoWindow({
                content: `
                <div style="width: 280px; padding: 2px; margin: 0;">
                <h2 style="font-size: 20px;">${marker.title}</h2>
                <hr/>
                <p><a href="${googleMapsLink}" target="_blank" style="">${marker.address}</a></p>
                </div>
                `
            });
            info.open(map, mark);

            map.setZoom(18);
            map.setCenter(mark.position);
        });
    });
}

getMap();

document.addEventListener('DOMContentLoaded', () => {
    // List of garages and their respective values (will update dynamically later on)
    const garages = [
        { totalSpots: 2031, spotsTaken: 540 },  // Cottage Grove Parking Garage
        { totalSpots: 1752, spotsTaken: 960 }, // Tropicana Parking Garage
        { totalSpots: 534, spotsTaken: 43 } // University Gateway Parking Garage
    ];

    // Set the values of the progress bar based on the above values
    document.querySelectorAll('.garage-info').forEach((garageInfo, index) => {
        const garageData = garages[index];
        const spotsRemaining = garageData.totalSpots - garageData.spotsTaken;
        const percentageRemaining = 100 - ((spotsRemaining / garageData.totalSpots) * 100).toFixed(0);

        // Update .percentRemainder text
        const percentRemainderElement = garageInfo.querySelector('.percentRemainder');
        percentRemainderElement.textContent = `${percentageRemaining}% Capacity`;

        // Update the progress bar value
        const progressElement = garageInfo.querySelector('progress');
        progressElement.value = percentageRemaining;
    });
});