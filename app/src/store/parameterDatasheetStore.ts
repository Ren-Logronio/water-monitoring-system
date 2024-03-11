import { type } from "os";
import { create } from "zustand";

type ParameterDatasheetStore = {
    columnLimits: any[];
    rowData: any[];
    setRowData: (rowData: any) => void;
    addRowData: (rowData: any) => void;
    editRowData: (rowData: any) => void;
    deleteRowData: (reading_id: number) => void;
}

export const useParameterDatasheetStore = create<ParameterDatasheetStore>((set) => ({
    columnLimits: [
        {
            colId: 'idx',
            maxWidth: 0
        },
        {
            colId: "actions",
            maxWidth: 0
        }
    ],
    rowData: [],
    setRowData: (rowData: any) => set({ rowData }),
    addRowData: (rowData: any) => {
        set((state: any) => ({ rowData: [...state.rowData, rowData] }))
    },
    editRowData: (rowData: any) => {
        set((state: any) => ({ rowData: state.rowData.map((row: any) => row.reading_id === rowData.reading_id ? { ...row, edit_recorded_at: rowData.edit_recorded_at, edit_time: rowData.edit_time, reading: rowData.reading, date: rowData.date, time: rowData.time } : row) }))
    },
    deleteRowData: (reading_id: number) => set((state: any) => ({ rowData: state.rowData.filter((rowData: any) => rowData.reading_id !== reading_id) })),
}));