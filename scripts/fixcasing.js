const fs = require('fs');
const args = process.argv;

if (args.length !== 5) {
    console.log('Run as: node index.js <metadata.json> <output.config> <output.config>')
    return;
}

const variablesPath = args[3];
const metadataPath = args[2];
const outputPath = args[4];

try {
    let variables = fs.readFileSync(variablesPath).toString();
    const metadataFile = fs.readFileSync(metadataPath).toString();

    const metadata = JSON.parse(metadataFile);

    const mapping = {};

    metadata['Constants'].forEach(c => {
        const name = c.Name;
        const newName = 'MX_' + name.replace(/\./g, '_').toUpperCase();
        const newNameOutput = 'MX_' + name.replace(/\./g, '_');
        mapping[newName] = newNameOutput;
    });

    Object.keys(mapping).forEach(key => {
        variables = variables.replace(key, mapping[key]);
    })

    fs.writeFileSync(outputPath, variables);
} catch (error) {
    console.log(error);
}
