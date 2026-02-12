class Calculator {
    constructor() {
        this.currentValue = '0';
        this.previousValue = '';
        this.operation = null;
        this.shouldResetScreen = false;
        this.history = '';
        
        this.currentDisplay = document.getElementById('current');
        this.historyDisplay = document.getElementById('history');
        
        this.setupKeyboardSupport();
    }
    
    setupKeyboardSupport() {
        document.addEventListener('keydown', (e) => {
            if (e.key >= '0' && e.key <= '9') this.appendNumber(e.key);
            if (e.key === '.') this.appendDecimal();
            if (e.key === '+' || e.key === '-' || e.key === '*' || e.key === '/') {
                this.appendOperator(e.key);
            }
            if (e.key === 'Enter' || e.key === '=') this.calculate();
            if (e.key === 'Escape') this.clearAll();
            if (e.key === 'Backspace') this.backspace();
        });
    }
    
    updateDisplay() {
        this.currentDisplay.textContent = this.currentValue;
        this.historyDisplay.textContent = this.history;
    }
    
    appendNumber(number) {
        if (this.shouldResetScreen) {
            this.currentValue = '';
            this.shouldResetScreen = false;
        }
        
        if (this.currentValue === '0') {
            this.currentValue = number;
        } else {
            this.currentValue += number;
        }
        
        this.updateDisplay();
    }
    
    appendDecimal() {
        if (this.shouldResetScreen) {
            this.currentValue = '0';
            this.shouldResetScreen = false;
        }
        
        if (!this.currentValue.includes('.')) {
            this.currentValue += '.';
        }
        
        this.updateDisplay();
    }
    
    appendOperator(operator) {
        if (this.operation !== null) {
            this.calculate();
        }
        
        this.previousValue = this.currentValue;
        this.operation = operator;
        this.history = `${this.previousValue} ${this.getOperatorSymbol(operator)}`;
        this.shouldResetScreen = true;
        this.updateDisplay();
    }
    
    getOperatorSymbol(operator) {
        const symbols = {
            '+': '+',
            '-': '−',
            '*': '×',
            '/': '÷',
            '%': '%'
        };
        return symbols[operator] || operator;
    }
    
    calculate() {
        if (this.operation === null || this.shouldResetScreen) return;
        
        let result;
        const prev = parseFloat(this.previousValue);
        const current = parseFloat(this.currentValue);
        
        switch (this.operation) {
            case '+':
                result = prev + current;
                break;
            case '-':
                result = prev - current;
                break;
            case '*':
                result = prev * current;
                break;
            case '/':
                if (current === 0) {
                    this.showError('Cannot divide by zero');
                    return;
                }
                result = prev / current;
                break;
            case '%':
                result = prev % current;
                break;
            default:
                return;
        }
        
        this.history = `${this.previousValue} ${this.getOperatorSymbol(this.operation)} ${this.currentValue} =`;
        this.currentValue = this.formatResult(result);
        this.operation = null;
        this.shouldResetScreen = true;
        this.updateDisplay();
    }
    
    formatResult(result) {
        // Handle very large or small numbers
        if (Math.abs(result) > 999999999 || (Math.abs(result) < 0.000001 && result !== 0)) {
            return result.toExponential(6);
        }
        
        // Round to avoid floating point precision issues
        const rounded = Math.round(result * 100000000) / 100000000;
        
        // Convert to string and remove trailing zeros
        let resultStr = rounded.toString();
        if (resultStr.includes('.')) {
            resultStr = resultStr.replace(/\.?0+$/, '');
        }
        
        return resultStr;
    }
    
    clearAll() {
        this.currentValue = '0';
        this.previousValue = '';
        this.operation = null;
        this.history = '';
        this.shouldResetScreen = false;
        this.updateDisplay();
    }
    
    clearEntry() {
        this.currentValue = '0';
        this.updateDisplay();
    }
    
    backspace() {
        if (this.currentValue.length > 1) {
            this.currentValue = this.currentValue.slice(0, -1);
        } else {
            this.currentValue = '0';
        }
        this.updateDisplay();
    }
    
    showError(message) {
        this.history = 'Error';
        this.currentValue = message;
        this.operation = null;
        this.shouldResetScreen = true;
        this.updateDisplay();
        
        setTimeout(() => {
            this.clearAll();
        }, 2000);
    }
}

// Initialize calculator
const calculator = new Calculator();

// Global functions for button onclick handlers
function appendNumber(num) {
    calculator.appendNumber(num);
}

function appendOperator(op) {
    calculator.appendOperator(op);
}

function appendDecimal() {
    calculator.appendDecimal();
}

function calculate() {
    calculator.calculate();
}

function clearAll() {
    calculator.clearAll();
}

function clearEntry() {
    calculator.clearEntry();
}

// Add some animations
document.addEventListener('DOMContentLoaded', () => {
    const buttons = document.querySelectorAll('.btn');
    
    buttons.forEach(button => {
        button.addEventListener('click', function() {
            this.style.transform = 'scale(0.95)';
            setTimeout(() => {
                this.style.transform = '';
            }, 100);
        });
    });
    
    // Add ripple effect
    buttons.forEach(button => {
        button.addEventListener('click', function(e) {
            const ripple = document.createElement('span');
            const rect = this.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const x = e.clientX - rect.left - size / 2;
            const y = e.clientY - rect.top - size / 2;
            
            ripple.style.width = ripple.style.height = size + 'px';
            ripple.style.left = x + 'px';
            ripple.style.top = y + 'px';
            ripple.classList.add('ripple');
            
            this.appendChild(ripple);
            
            setTimeout(() => {
                ripple.remove();
            }, 600);
        });
    });
});

// Add ripple effect styles
const style = document.createElement('style');
style.textContent = `
    .btn {
        position: relative;
        overflow: hidden;
    }
    
    .ripple {
        position: absolute;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.6);
        transform: scale(0);
        animation: ripple-animation 0.6s ease-out;
        pointer-events: none;
    }
    
    @keyframes ripple-animation {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);
