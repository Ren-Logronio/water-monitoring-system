
import VectorSource from "ol/source/Vector";
import { create } from "zustand";

interface vectorSourceStore {
    polygonVectorSource: VectorSource | null;
    pointVectorSource: VectorSource | null;
    labelVectorSource: VectorSource | null;

    setPolygonVectorSource: (polygonVectorSource: VectorSource) => void;
    setPointVectorSource: (pointVectorSource: VectorSource) => void;
    setLabelVectorSource: (labelVectorSource: VectorSource) => void;
}

export const useVectorSourceStore = create<vectorSourceStore>((set) => ({
    polygonVectorSource: null,
    pointVectorSource: null,
    labelVectorSource: null,

    setPolygonVectorSource: (polygonVectorSource: VectorSource) => set({ polygonVectorSource }),
    setPointVectorSource: (pointVectorSource: VectorSource) => set({ pointVectorSource }),
    setLabelVectorSource: (labelVectorSource: VectorSource) => set({ labelVectorSource }),
}));