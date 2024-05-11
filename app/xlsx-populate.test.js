const XlsxPopulate = require('xlsx-populate');
const fs = require('fs').promises;

// Path to input and output files
const inputFile = 'xlsx-populate.test.xlsx';
const outputFile = 'xlsx-populate.test.result.xlsx';

// Function to populate A1 and B1 with values and save the file
async function populateAndSave() {
  try {
    // Load the workbook
    const workbook = await XlsxPopulate.fromFileAsync(inputFile);

    // Get the first sheet
    const sheet = workbook.sheet(0);

    // Populate cells A1 and B1
    sheet.cell('A1').value(5);
    sheet.cell('B1').value(10);

    const buffer = await workbook.outputAsync();

    // Save the workbook, replace if the file exists already
    await fs.writeFile(outputFile, buffer);

    console.log('File saved successfully.');
  } catch (error) {
    console.error('Error:', error);
  }
}

// Call the function
populateAndSave();