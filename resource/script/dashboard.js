
// NOTE - PLACEHOLDER DATA FOR TESTING PURPOSES

const ids = ['temperature', 'salinity', 'ph', 'dissolved-oxygen', 'ammonia']
var chartData = {
    "labels": [
        "week 1",
        "week 2",
        "week 3",
        "week 4"
    ],
    "datasets": [
        {
        "backgroundColor": "#b3d4ff",
        "fill": true,
        "data": [
            "230",
            "250",
            "260",
            "240"
        ],
        "borderColor": "#ffffff",
        "borderWidth": "1"
        }
    ]
};
var chartOptions = {
    "title": {
        "display": false,
        "text": "",
        "position": "bottom",
        "fullWidth": true,
        "fontColor": "#aa7942",
        "fontSize": 16
    },
    "legend": {
        "display": false,
        "fullWidth": false,
        "position": "top"
    },
    "scales": {
        "yAxes": [
        {
            "ticks": {
            "beginAtZero": false,
            "display": true
            },
            "gridLines": {
            "display": true,
            "lineWidth": 2,
            "drawOnChartArea": true,
            "drawTicks": true,
            "tickMarkLength": 1,
            "offsetGridLines": true,
            "zeroLineColor": "#942192",
            "color": "#d6d6d6",
            "zeroLineWidth": 2
            },
            "scaleLabel": {
            "display": true,
            "labelString": "Degrees Celsius"
            },
            "display": true
        }
        ],
        "xAxes": {
        "0": {
            "ticks": {
            "display": true,
            "fontSize": 14,
            "fontStyle": "italic"
            },
            "display": true,
            "gridLines": {
            "display": true,
            "lineWidth": 2,
            "drawOnChartArea": false,
            "drawTicks": true,
            "tickMarkLength": 12,
            "zeroLineWidth": 2,
            "offsetGridLines": true,
            "color": "#942192",
            "zeroLineColor": "#942192"
            },
            "scaleLabel": {
            "fontSize": 16,
            "display": true,
            "fontStyle": "normal",
            "labelString": "Month of August"
            }
        }
        }
    },
    "tooltips": {
        "enabled": false,
        "mode": "label",
        "caretSize": 10,
        "backgroundColor": "#00fa92"
    }
};
  
document.addEventListener('DOMContentLoaded', () => {
    ids.forEach(id => {
        const ctx = document.getElementById(id).getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: chartData,
            options: chartOptions
        });
    });
});