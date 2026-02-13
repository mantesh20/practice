#!/usr/bin/env node

// Validation script for CI/CD
const fs = require('fs');
const path = require('path');

console.log('🔍 Validating project files...');

// Check required files
const requiredFiles = [
  'code/calculator.html',
  'code/calculator.css', 
  'code/calculator.js',
  'code/Dockerfile.simple',
  'CICD/index.html',
  'CICD/Dockerfile.cicd'
];

let allValid = true;

requiredFiles.forEach(file => {
  if (fs.existsSync(file)) {
    console.log(`✅ ${file} exists`);
  } else {
    console.log(`❌ ${file} missing`);
    allValid = false;
  }
});

// Check Docker files content
try {
  const cicdDockerfile = fs.readFileSync('CICD/Dockerfile.cicd', 'utf8');
  if (cicdDockerfile.includes('FROM nginx:alpine')) {
    console.log('✅ CICD Dockerfile is valid');
  } else {
    console.log('❌ CICD Dockerfile invalid');
    allValid = false;
  }
} catch (error) {
  console.log('❌ Error reading CICD Dockerfile');
  allValid = false;
}

try {
  const calcDockerfile = fs.readFileSync('code/Dockerfile.simple', 'utf8');
  if (calcDockerfile.includes('FROM nginx:alpine')) {
    console.log('✅ Calculator Dockerfile is valid');
  } else {
    console.log('❌ Calculator Dockerfile invalid');
    allValid = false;
  }
} catch (error) {
  console.log('❌ Error reading Calculator Dockerfile');
  allValid = false;
}

// Check HTML files
try {
  const cicdHtml = fs.readFileSync('CICD/index.html', 'utf8');
  if (cicdHtml.includes('<!DOCTYPE html>')) {
    console.log('✅ CICD HTML is valid');
  } else {
    console.log('❌ CICD HTML invalid');
    allValid = false;
  }
} catch (error) {
  console.log('❌ Error reading CICD HTML');
  allValid = false;
}

try {
  const calcHtml = fs.readFileSync('code/calculator.html', 'utf8');
  if (calcHtml.includes('<!DOCTYPE html>')) {
    console.log('✅ Calculator HTML is valid');
  } else {
    console.log('❌ Calculator HTML invalid');
    allValid = false;
  }
} catch (error) {
  console.log('❌ Error reading Calculator HTML');
  allValid = false;
}

if (allValid) {
  console.log('🎉 All validations passed!');
  process.exit(0);
} else {
  console.log('❌ Validation failed!');
  process.exit(1);
}
