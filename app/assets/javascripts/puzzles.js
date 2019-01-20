var map;

function initMap() {
  map = new ol.Map({
    target: 'map',
    layers: [
      new ol.layer.Tile({
        source: new ol.source.OSM()
      })
    ],
    view: new ol.View({
      center: ol.proj.fromLonLat([16.2, 49.2]),
      zoom: 10
    })
  });
}

function addMapPoint(longitude, latitude) {
  var vectorLayer = new ol.layer.Vector({
    source: new ol.source.Vector({
      features: [
        new ol.Feature({
          geometry: new ol.geom.Point(
            ol.proj.fromLonLat([longitude, latitude])
          )
        })
      ]
    }),
    style: new ol.style.Style({
      image: new ol.style.Icon({
        anchor: [0.5, 0.5],
        anchorXUnits: "fraction",
        anchorYUnits: "fraction",
        src: "https://upload.wikimedia.org/wikipedia/commons/e/ec/RedDot.svg"
      })
    })
  });
  map.addLayer(vectorLayer);
}

function showMyPosition() {
  navigator.geolocation.getCurrentPosition(
    function(position) {
      addMapPoint(position.coords.longitude, position.coords.latitude);
    }
  )
}

$(document).on('turbolinks:load', function() {
  var data = $('body').data();
  console.log(data.controller + '#' + data.action);
  if (data.controller == 'puzzles' && data.action == 'map') {
    initMap();
  }
});
