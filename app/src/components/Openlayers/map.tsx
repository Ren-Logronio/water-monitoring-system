'use client';

import { useEffect, useRef, useCallback, HTMLAttributes } from "react";
import { BING_API_KEY } from "./utils/bingmaps.key";

import { useGeographic } from "ol/proj";
import Map from "ol/Map";
import View from "ol/View";
import TileLayer from "ol/layer/Tile";
import BingMaps from "ol/source/BingMaps";
import VectorLayer from "ol/layer/Vector";
import { selectInteraction } from "./utils/select";
import Feature from "ol/Feature";
import React from "react";
import { Color } from "ol/color";
import { styleAssigned } from "./utils/vectorStyle";
import VectorSource from "ol/source/Vector";
import { pinStyle } from "./utils/styles/pinStyle";
import { addPoints } from "./utils/addPoints";
import { removePoints } from "./utils/removePoints";

const MapView = () => {

    // map component
    let mapObj: Map | null = null;
    // selected feature
    let selected: Feature<any> | null = null;
    // vector layer
    let vector_Layer: VectorLayer<any> | null = null;
    // vector source
    let vector_Source: VectorSource | null = null;

    // map component
    const MapBuilder = React.memo(({ vectorLayer, labelLayer, className, zoom, center, pin, onMapClick, pinOnCenter, pinOnCenterLabel }: {
        vectorLayer: VectorLayer<any> | null,
        labelLayer?: VectorLayer<any>,
        className: HTMLAttributes<HTMLElement>['className'],
        zoom?: number,
        center?: [number, number],
        pin?: boolean,
        pinOnCenter?: boolean,
        pinOnCenterLabel?: string,
        onMapClick?: (latitude: number, longitude: number) => void
    }) => {

        // if vector layer is provided
        if (vectorLayer) {
            // set the vector layer
            vector_Layer = vectorLayer;
            // set the vector source
            vector_Source = vectorLayer?.getSource() || null;
        }

        // create a ref for the map
        const mapRef = useRef<HTMLDivElement>(null);

        // handle feature selection event
        const handleFeatureSelection = useCallback((selectedFeature: Feature<any> | null) => {
            selectedFeature ? selected = selectedFeature : selected = null;
        }, []);

        // for geographic projection
        useGeographic();

        // initialize the map
        useEffect(() => {
            // do nothing if mapRef is not yet initialized
            if (!mapRef.current) return;

            // create the map
            const map = new Map({
                target: mapRef.current,
                layers: [
                    new TileLayer({
                        preload: Infinity,
                        visible: true,
                        source: new BingMaps({
                            key: BING_API_KEY!,
                            imagerySet: "AerialWithLabels",
                            maxZoom: 19,
                        }),
                    }),
                ],
                view: new View({
                    center: center ? center : [125.106098, 5.959807],
                    zoom: zoom ? zoom : 18.5,
                    //extent: [125.102278, 5.956575, 125.108819, 5.962964],
                }),
                controls: [],
            });

            // set the map object
            if (map) mapObj = map;

            pinOnCenter && addPoints(center!, pinOnCenterLabel || "Farm Location", "pin");

            // add the vector & label layers to the map
            vectorLayer && map.addLayer(vectorLayer);

            // when the pointer is moved
            // change the cursor to pointer if the pointer is on a feature
            map.on("pointermove", (event) => {
                const hit = map.forEachFeatureAtPixel(event.pixel, (feature) => feature);
                map.getTargetElement().style.cursor = hit ? "pointer" : "";
            });

            // when the map is clicked
            // get the location
            map.on("click", (event) => {
                if (!pin) return;
                const hit = event.coordinate;
                // add a pin to the map
                removePoints("pin");
                console.log("removed pin");
                addPoints(hit, "", "pin");
                onMapClick && onMapClick(hit[1], hit[0]);
                console.log(`latitute: ${hit[1]}, longitude: ${hit[0]}`);
            });

            // add the select interaction to the map
            // const select = selectInteraction(handleFeatureSelection).newSelect(vectorLayer);
            // map.addInteraction(select);


            // on component unmount remove the map refrences to avoid unexpected behaviour
            return () => {
                // remove the map when the component is unmounted
                removePoints("pin");
                map.setTarget(undefined);
                // remove the select interaction
                // if (select) {
                //     map.removeInteraction(select);
                // }
            };
        }, [handleFeatureSelection, zoom, labelLayer, vectorLayer]);

        useEffect(() => {
            if (!pin) {
                removePoints("pin");
            }
        }, [pin])


        // map zoom level changes
        useEffect(() => {
            // do nothing if the map object is not yet initialized
            if (!mapObj) return;

            // when the zoom level changes
            mapObj.getView().on("change:resolution", (event) => {
                const newZoomLevel = event.target.getZoom()

                // get the features of the vector source
                const features = vector_Source?.getFeatures();

                // change the style of the features based on the zoom level
                features?.forEach((feature) => {
                    const name = feature.get("name");
                    feature.setStyle(pinStyle(name, newZoomLevel));
                });

            });
        }, []);

        // return the map
        return <div ref={mapRef} className={`overflow-hidden rounded-3xl ${className}`}></div> as JSX.Element;

    });

    // set display name
    MapBuilder.displayName = "MapBuilder";

    // selected feature method
    const getSelectedFeature = () => {
        return selected;
    }

    // highlight assigned features method
    // const highlightFeatures = (pond_data: map_attributes[]) => {
    //     // do nothing if the vector layer is not yet initialized
    //     if (!vector_Layer) return;

    //     // get the features
    //     const features = vector_Layer.getSource().getFeatures();

    //     // iterate over each ID and color pair
    //     pond_data.forEach(([id, color]) => {
    //         // find and update the corresponding feature
    //         features.forEach((feature: Feature) => {
    //             if (feature.getId() === id) {
    //                 feature.setStyle(styleAssigned(color));
    //             }
    //         });
    //     });
    // }


    // return the methods for the map
    return {
        newMap: MapBuilder,
        selectedFeature: getSelectedFeature,
        //assignedPonds: highlightFeatures,
    }
};

export default MapView;