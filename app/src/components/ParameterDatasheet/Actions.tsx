import { Button } from "../ui/button";
import DeleteReading from "./DeleteReading";
import EditReading from "./EditReading";

export default function Actions({ getValue }: { getValue: () => any }) {
    const handleEdit = () => {
        console.log("Edit IDX:", getValue());
    }

    const handleDelete = () => {
        console.log("Delete IDX:", getValue().reading_id);
    }

    return <div className="flex flex-row justify-even items-center space-x-4">
        <EditReading reading={getValue()} />
        <DeleteReading reading_id={getValue().reading_id} />
    </div>
}