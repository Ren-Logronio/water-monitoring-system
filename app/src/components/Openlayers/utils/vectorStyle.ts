//used for styling the vectors
import { Color } from "ol/color";
import Fill from "ol/style/Fill";
import Stroke from "ol/style/Stroke";
import Style from "ol/style/Style";
import Text from "ol/style/Text";
import { asArray as colorAsArray } from "ol/color";


// style for all features
export const styleNormal = new Style({
    fill: new Fill({
        color: "rgba(255, 255, 255, 0.2)",
    }),
    stroke: new Stroke({
        color: "white",
        width: 2,
    }),

});

// style for selected feature
export const styleSelected = new Style({
    fill: new Fill({
        color: "rgba(255, 255, 255, 0.5)",
    }),
    stroke: new Stroke({
        color: "#ffcc33",
        width: 3,
    }),
});

// style for features assigned to a pond
export const styleAssigned = (color: Color | string) => {
    // convert the color to an array to create an rgba color
    let rgba = colorAsArray(color);
    rgba = rgba.slice(); 
    rgba[3] = 0.30;  

    return new Style({
        fill: new Fill({
            color: rgba,  // use the modified rgba array
        }),
        stroke: new Stroke({
            color: "white",
            width: 3,
        }),
    });
};



// style for text
export const styleText = (label: any) => new Style({
    text: new Text({
        text: label,
        font: "13px Arial",
        fill: new Fill({
            color: "white",
        }),
        // stroke: new Stroke({
        //     color: "#fff", // label text outline color
        //     width: 2,
        // }),
    }),
});