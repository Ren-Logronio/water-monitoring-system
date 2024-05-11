
import VectorLayer from "ol/layer/Vector";
import { create } from "zustand";

interface vectorLayerStore {
    polygonVectorLayer: VectorLayer<any> | null;
    labelVectorLayer: VectorLayer<any> | null;

    setPolygonVectorLayer: (polygonVectoLayer: VectorLayer<any>) => void;
    setLabelVectorLayer: (labelVectorLayer: VectorLayer<any>) => void;
}

export const useVectorLayerStore = create<vectorLayerStore>((set) => ({
    polygonVectorLayer: null,
    labelVectorLayer: null,

    setPolygonVectorLayer: (polygonVectorLayer: VectorLayer<any>) => set({ polygonVectorLayer }),
    setLabelVectorLayer: (labelVectorLayer: VectorLayer<any>) => set({ labelVectorLayer }),
}));