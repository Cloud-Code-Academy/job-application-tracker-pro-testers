import { LightningElement, track, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = ['opportunity.Salary__c'];

const mcrRate = 0.0145;
const ssRate = 0.0620;

// Define federal tax brackets and rates
const federalTaxBrackets = [
    { min: 0,       max: 11000,     rate: 0.10 },
    { min: 11001,   max: 44725,     rate: 0.12 },
    { min: 44726,   max: 95375,     rate: 0.22 },
    { min: 95376,   max: 182100,    rate: 0.24 },
    { min: 182101,  max: 231250,    rate: 0.32 },
    { min: 231251,  max: 578125,    rate: 0.35 },
    { min: 578126,  max: Infinity,  rate: 0.37 }
];

const standardSingleDeduction = 13850.00;

export default class TakeHomePayCalculator extends LightningElement {
    @api recordId;

    @track income = 0;
    @track taxableIncome = 0;
    @track takeHomePay = 0;
    @track semiAnnualPay = 0;
    @track monthlyPay = 0;
    @track biWeeklyPay = 0;
    @track federalWithholding = 0;
    @track yearlyPay = 0;
    @track ssWithholding = 0;
    @track mcrWithholding = 0;
    @track salaryDeductions = 0;
    
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (data) {
            this.income = data.fields.Salary__c.value;
            // console.log('***income:', this.income);
            this.handleCalculate();
        } else if (error) {
            console.error('***Error loading record', error);
        }
    }

    handleCalculate() {
        // Calculate the Take Home Pay
        this.federalWithholding = this.calculateFederalTax().toFixed(2);
        this.taxableIncome = this.income > standardSingleDeduction ? this.income - standardSingleDeduction : this.income;
        this.mcrWithholding = this.income * mcrRate;
        this.ssWithholding = (this.income * ssRate).toFixed(2);
        this.salaryDeductions = this.federalWithholding - this.mcrWithholding - this.ssWithholding;
        this.salaryDeductions = this.salaryDeductions < 0 ? this.salaryDeductions * -1 : this.salaryDeductions;
        this.takeHomePay = (this.income - this.salaryDeductions).toFixed(2);
        this.semiAnnualPay  = (this.takeHomePay / 2).toFixed(2);
        this.monthlyPay     = (this.takeHomePay / 12).toFixed(2);
        this.biWeeklyPay    = (this.takeHomePay / 26).toFixed(2);
    }

    calculateFederalTax() {
        // Calculate the federal tax based on the income
        let federalTax = 0;
        let incomeMinusStandardSingleDeduction = this.income - standardSingleDeduction;
        // console.log('***incomeMinusStandardSingleDeduction: ', incomeMinusStandardSingleDeduction);
        
        for (const bracket of federalTaxBrackets) {
            if (incomeMinusStandardSingleDeduction <= bracket.max || !bracket.max) {
                // console.log('***bracket.rate: ', bracket.rate);
                federalTax = (bracket.rate * (incomeMinusStandardSingleDeduction - bracket.min)) + (bracket.min * bracket.rate);
                break;
            }
        }
        return federalTax > 0 ? federalTax : 0;
    }

    handleChange(event) {
        // Update the label from the corresponding event that triggered it
        const fieldName = event.target.label;
        this[fieldName.toLowerCase()] = parseFloat(event.target.value);
    }

}