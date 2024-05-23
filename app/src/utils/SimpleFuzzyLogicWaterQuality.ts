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

export const weights = {
    'ph': 0.10,
    'tds': 0.25,
    'ammonia': 0.25,
    'temperature': 0.40
};

export const phThresholds = [6.5, 7.5, 8.5];
export const tdsThresholds = [100, 350, 600];
export const ammoniaThresholds = [-999999999, 150, 300];
export const temperatureThresholds = [20, 25, 30];


export function calculateWQI(parameters: { ph: number, tds: number, ammonia: number, temperature: number }) {
    const before = performance.now();


    // Calculate membership degrees
    const phDegree = calculateMembership(parameters.ph, phThresholds);
    const tdsDegree = calculateMembership(parameters.tds, tdsThresholds);
    const ammoniaDegree = calculateMembership(parameters.ammonia, ammoniaThresholds);
    const temperatureDegree = calculateMembership(parameters.temperature, temperatureThresholds);

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

export function calculateWQIDebug(ph: number, tds: number, ammonia: number, temperature: number) {
    const before = performance.now();

    // Calculate membership degrees
    const phDegree = calculateMembership(ph, phThresholds);
    const tdsDegree = calculateMembership(tds, tdsThresholds);
    const ammoniaDegree = calculateMembership(ammonia, ammoniaThresholds);
    const temperatureDegree = calculateMembership(temperature, temperatureThresholds);

    // Calculate weighted average of membership degrees
    const wqi = (
        weights['ph'] * phDegree +
        weights['tds'] * tdsDegree +
        weights['ammonia'] * ammoniaDegree +
        weights['temperature'] * temperatureDegree
    );

    const after = performance.now();
    console.log("Time taken to calculate WQI", after - before, "ms");
    return { ph: phDegree, tds: tdsDegree, ammonia: ammoniaDegree, temperature: temperatureDegree, wqi };
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

export const wqiClassificationColorHex: any = {
    "Excellent": "#00FF00",
    "Good": "#00A86B",
    "Fair": "#FFD700",
    "Poor": "#FFA500",
    "Very Poor": "#FF0000"
};