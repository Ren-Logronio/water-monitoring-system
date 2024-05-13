import Fill from "ol/style/Fill";
import Icon from "ol/style/Icon";
import Style from "ol/style/Style";
import Text from "ol/style/Text";

export const pinStyle = (name: string, zoomLevel? : number) => {
    return new Style({
        image: new Icon({
            anchor: [0.5, 1],
            src: "/pin-location.png",
            scale: 1,
            crossOrigin: "anonymous",
        }),

        // show the text if the zoom level is greater than or equal to 18.5
        text: new Text({
            text: name,
            font: "12px Arial",
            fill: new Fill({
                color: "white",
            }),
            offsetY: -15,
            offsetX: 35,
        }),
    })
};