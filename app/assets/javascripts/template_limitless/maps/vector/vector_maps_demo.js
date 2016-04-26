/* ------------------------------------------------------------------------------
*
*  # Vector maps
*
*  Specific JS code additions for maps_vector.html page
*
*  Version: 1.0
*  Latest update: Aug 1, 2015
*
* ---------------------------------------------------------------------------- */

$(function() {

    // World map
    $('.map-world').vectorMap({
        map: 'world_mill_en',
        backgroundColor: 'transparent',
        regionStyle: {
            initial: {
                fill: '#93D389'
            }
        }
    });


    // Custom markers
    $('.map-world-markers').vectorMap({
        map: 'world_mill_en',
        backgroundColor: 'transparent',
        scaleColors: ['#C8EEFF', '#0071A4'],
        normalizeFunction: 'polynomial',
        regionStyle: {
            initial: {
                fill: '#D6E1ED'
            }
        },
        hoverOpacity: 0.7,
        hoverColor: false,
        markerStyle: {
            initial: {
                r: 7,
                'fill': '#336BB5',
                'fill-opacity': 0.8,
                'stroke': '#fff',
                'stroke-width' : 1.5,
                'stroke-opacity': 0.9
            },
            hover: {
                'stroke': '#fff',
                'fill-opacity': 1,
                'stroke-width': 1.5
            }
        },
        focusOn: {
            x: 0.5,
            y: 0.5,
            scale: 2
        },
        markers: [
            {latLng: [41.90, 12.45], name: 'Vatican City'},
            {latLng: [43.73, 7.41], name: 'Monaco'},
            {latLng: [40.726, -111.778], name: 'Salt Lake City'},
            {latLng: [39.092, -94.575], name: 'Kansas City'},
            {latLng: [25.782, -80.231], name: 'Miami'},
            {latLng: [8.967, -79.458], name: 'Panama City'},
            {latLng: [19.400, -99.124], name: 'Mexico City'},
            {latLng: [40.705, -73.978], name: 'New York'},
            {latLng: [33.98, -118.132], name: 'Los Angeles'},
            {latLng: [47.614, -122.335], name: 'Seattle'},
            {latLng: [44.97, -93.261], name: 'Minneapolis'},
            {latLng: [39.73, -105.015], name: 'Denver'},
            {latLng: [41.833, -87.732], name: 'Chicago'},
            {latLng: [29.741, -95.395], name: 'Houston'},
            {latLng: [23.05, -82.33], name: 'Havana'},
            {latLng: [45.41, -75.70], name: 'Ottawa'},
            {latLng: [53.555, -113.493], name: 'Edmonton'},
            {latLng: [-0.23, -78.52], name: 'Quito'},
            {latLng: [18.50, -69.99], name: 'Santo Domingo'},
            {latLng: [4.61, -74.08], name: 'Bogotá'},
            {latLng: [14.08, -87.21], name: 'Tegucigalpa'},
            {latLng: [17.25, -88.77], name: 'Belmopan'},
            {latLng: [14.64, -90.51], name: 'New Guatemala'},
            {latLng: [-15.775, -47.797], name: 'Brasilia'},
            {latLng: [-3.790, -38.518], name: 'Fortaleza'},
            {latLng: [50.402, 30.532], name: 'Kiev'},
            {latLng: [53.883, 27.594], name: 'Minsk'},
            {latLng: [52.232, 21.061], name: 'Warsaw'},
            {latLng: [52.507, 13.426], name: 'Berlin'},
            {latLng: [50.059, 14.465], name: 'Prague'},
            {latLng: [47.481, 19.130], name: 'Budapest'},
            {latLng: [52.374, 4.898], name: 'Amsterdam'},
            {latLng: [48.858, 2.347], name: 'Paris'},
            {latLng: [40.437, -3.679], name: 'Madrid'},
            {latLng: [39.938, 116.397], name: 'Beijing'},
            {latLng: [28.646, 77.093], name: 'Delhi'},
            {latLng: [25.073, 55.229], name: 'Dubai'},
            {latLng: [35.701, 51.349], name: 'Tehran'},
            {latLng: [7.11, 171.06], name: 'Marshall Islands'},
            {latLng: [17.3, -62.73], name: 'Saint Kitts and Nevis'},
            {latLng: [3.2, 73.22], name: 'Maldives'},
            {latLng: [35.88, 14.5], name: 'Malta'},
            {latLng: [12.05, -61.75], name: 'Grenada'},
            {latLng: [13.16, -61.23], name: 'Saint Vincent and the Grenadines'},
            {latLng: [13.16, -59.55], name: 'Barbados'},
            {latLng: [17.11, -61.85], name: 'Antigua and Barbuda'},
            {latLng: [-4.61, 55.45], name: 'Seychelles'},
            {latLng: [7.35, 134.46], name: 'Palau'},
            {latLng: [42.5, 1.51], name: 'Andorra'},
            {latLng: [14.01, -60.98], name: 'Saint Lucia'},
            {latLng: [6.91, 158.18], name: 'Federated States of Micronesia'},
            {latLng: [1.3, 103.8], name: 'Singapore'},
            {latLng: [1.46, 173.03], name: 'Kiribati'},
            {latLng: [-21.13, -175.2], name: 'Tonga'},
            {latLng: [15.3, -61.38], name: 'Dominica'},
            {latLng: [-20.2, 57.5], name: 'Mauritius'},
            {latLng: [26.02, 50.55], name: 'Bahrain'},
            {latLng: [0.33, 6.73], name: 'São Tomé and Príncipe'}
        ]
    });


});
