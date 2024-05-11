import moment from "moment";

export function fromDatabaseTimestampFormat(date: string) {
    return;
}

export default function toDatabaseTimestampFormat(date: string) {
    return moment(date).format("YYYY-MM-DD HH:MM:SS");
}