//'use client';

import { HTMLProps, useEffect, useRef, useState } from "react";
import { BING_API_KEY } from "./utils/bingmaps.key";

import { useGeographic } from "ol/proj";
import Map from "ol/Map";
import View from "ol/View";
import TileLayer from "ol/layer/Tile";
import BingMaps from "ol/source/BingMaps";

import { vectorLayer } from "./utils/vectorSource";
import { selectInteraction } from "./utils/select";
import { Select } from "ol/interaction";


export const MapView = (
    { classname, zoom }: { classname: HTMLProps<HTMLElement>["className"], zoom?: number }

) => {
    const mapRef = useRef<HTMLDivElement>(null);
    const [select, setSelect] = useState<Select | null>(null);

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

        // add the vector layer to the map
        if (vectorLayer) {
            map.addLayer(vectorLayer);
        }

        // add the select interaction to the map
        const select = selectInteraction();
        map.addInteraction(select);
        setSelect(select);

        // on component unmount remove the map refrences to avoid unexpected behaviour
        return () => {
            // remove the map when the component is unmounted
            map.setTarget(undefined);

            if (select) {
                map.removeInteraction(select);
                setSelect(null);
            }
        };

    }, [zoom])

    // return the map
    return <div ref={mapRef} className={`overflow-hidden rounded-3xl ${classname}`}></div>
}