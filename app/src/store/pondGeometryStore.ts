import Feature from "ol/Feature";
import { create } from "zustand";


interface PondGeometryStore {
    ponds: Feature[];
    labels: Feature[];
    storePonds: (ponds: Feature[]) => void;
    storeLabels: (labels: Feature[]) => void;
    updateLabels: (id: number, label: string) => void;
}


export const usePondGeometryStore = create<PondGeometryStore>((set) => ({
    ponds: [],
    labels: [],

    // store the ponds
    storePonds: (ponds: Feature[]) => { 
        set((state) => {
            return {
                ponds: [...state.ponds, ...ponds], 
            };
        });
    },

    // store the labels
    storeLabels: (labels: Feature[]) => {
        set((state) => {
            return {
                labels: [...state.labels, ...labels],
            };
        });
    },

    // update the labels by id
    updateLabels: (id: number, label: string) => {
        set((state) => {
            // find the feature by id
            let feature = state.labels.find((feature) => feature.getId() === id);
            
            // update the label
            if (feature) {
                feature.set("name", label);
            }
            return state;
        });
    },
}));