export function calculateMembership(param: number, thresholds: number[]) {
    if (param <= thresholds[0] || param >= thresholds[2]) {
        return 0;
    } else if (param > thresholds[0] && param <= thresholds[1]) {
        return (param - thresholds[0]) / (thresholds[1] - thresholds[0]);
    } else if (param > thresholds[1] && param < thresholds[2]) {
        return (thresholds[2] - param) / (thresholds[2] - thresholds[1]);
    }
    return 0;
}


export function calculateWQI(ph: number, tds: number, ammonia: number, temperature: number) {
    const before = performance.now();
    // Define thresholds for each parameter
    const phThresholds = [6, 6.5, 9];
    const tdsThresholds = [0, 500, 1000];
    const ammoniaThresholds = [0, 150, 300];
    const temperatureThresholds = [20, 25, 30];

    // Calculate membership degrees
    const phDegree = calculateMembership(ph, phThresholds);
    const tdsDegree = calculateMembership(tds, tdsThresholds);
    const ammoniaDegree = calculateMembership(ammonia, ammoniaThresholds);
    const temperatureDegree = calculateMembership(temperature, temperatureThresholds);

    // Define weightage factors for each parameter
    const weights = {
        'ph': 0.30,
        'tds': 0.15,
        'ammonia': 0.25,
        'temperature': 0.30
    };

    // Calculate weighted average of membership degrees
    const wqi = (
        weights['ph'] * phDegree +
        weights['tds'] * tdsDegree +
        weights['ammonia'] * ammoniaDegree +
        weights['temperature'] * temperatureDegree
    );

    const after = performance.now();
    console.log("Time taken to calculate WQI", after - before, "ms");
    return wqi;
}


export function classifyWQI(wqi: number) {
    if (wqi >= 0.9) {
        return "Excellent";
    } else if (wqi >= 0.75 && wqi < 0.9) {
        return "Good";
    } else if (wqi >= 0.5 && wqi < 0.75) {
        return "Fair";
    } else if (wqi >= 0.25 && wqi < 0.5) {
        return "Poor";
    } else {
        return "Very Poor";
    }
}

export const wqiClassificationColorHex = {
    "Excellent": "#00FF00",
    "Good": "#00A86B",
    "Fair": "#FFD700",
    "Poor": "#FFA500",
    "Very Poor": "#FF0000"
};