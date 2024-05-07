'use client';

import { HTMLProps, useEffect, useRef, useState } from "react";
import { BING_API_KEY } from "./utils/bingmaps.key";

import { useGeographic } from "ol/proj";
import Map from "ol/Map";
import View from "ol/View";
import TileLayer from "ol/layer/Tile";
import BingMaps from "ol/source/BingMaps";
import VectorLayer from "ol/layer/Vector";
import { selectInteraction } from "./utils/select";
import Feature from "ol/Feature";



export const MapView = () => {
    // create a ref for the map
    const mapRef = useRef<HTMLDivElement>(null);
    const [selectedFeature, setSelectedFeature] = useState<Feature<any> | null>(null);

    // handle feature selection event
    const handleFeatureSelection = (selectedFeature: Feature<any> | null) => {
        console.log(selectedFeature?.getProperties());
        setSelectedFeature(selectedFeature);
    };

    // return the selected feature
    const getSelectedFeature = () => {
        return selectedFeature;
    }

    const NewMap = ({ vectorLayer, labelLayer, className, zoom }:
        {
            vectorLayer: VectorLayer<any>,
            labelLayer: VectorLayer<any>,
            className: HTMLProps<HTMLElement>["className"],
            zoom?: number,
        }) => {

        // for geographic projection
        useGeographic();

        // initialize the map
        useEffect(() => {
            // do nothing if mapRef is not yet initialized
            if (!mapRef.current) return;

            // create the map
            const map = new Map({
                target: mapRef.current!,
                layers: [
                    new TileLayer({
                        preload: Infinity,
                        visible: true,
                        source: new BingMaps({
                            key: BING_API_KEY!,
                            imagerySet: "Aerial",
                            maxZoom: 19,
                        }),
                    }),
                ],
                view: new View({
                    center: [125.106098, 5.959807],
                    zoom: !zoom ? 18.5 : zoom,
                    extent: [125.102278, 5.956575, 125.108819, 5.962964],
                }),
                controls: [],
            });

            // add the vector & label layers to the map
            map.addLayer(vectorLayer);
            map.addLayer(labelLayer);

            // add the select interaction to the map
            const select = selectInteraction(handleFeatureSelection).newSelect(vectorLayer);
            map.addInteraction(select);


            // on component unmount remove the map refrences to avoid unexpected behaviour
            return () => {
                // remove the map when the component is unmounted
                map.setTarget(undefined);
                // remove the select interaction
                if (select) {
                    map.removeInteraction(select);
                }
            };
        }, [zoom, labelLayer, vectorLayer]);


        // return the map
        return <div ref={mapRef} className={`overflow-hidden rounded-3xl ${className}`}></div> as JSX.Element;

    }

    // return the methods
    return {
        newMap: NewMap,
        selectedFeature: getSelectedFeature,
    }
}