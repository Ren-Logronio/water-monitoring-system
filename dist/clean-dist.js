const fs = require('fs');
const path = require('path');

const distIndexPath = path.join(__dirname, 'index.html');
const distAssetsPath = path.join(__dirname, 'assets');

try {
  // Delete ./dist/index.html file
  fs.unlinkSync(distIndexPath);
  console.log(`${distIndexPath} deleted successfully.`);

  // Delete ./dist/assets directory and its contents
  deleteFolderRecursive(distAssetsPath);
  console.log(`${distAssetsPath} deleted successfully.`);
} catch (error) {
  console.error('Error:', error.message);
}

function deleteFolderRecursive(folderPath) {
  if (fs.existsSync(folderPath)) {
    fs.readdirSync(folderPath).forEach((file) => {
      const currentPath = path.join(folderPath, file);
      if (fs.lstatSync(currentPath).isDirectory()) {
        // Recursive call for directories
        deleteFolderRecursive(currentPath);
      } else {
        // Delete file
        fs.unlinkSync(currentPath);
      }
    });

    // Delete the empty directory
    fs.rmdirSync(folderPath);
  }
}