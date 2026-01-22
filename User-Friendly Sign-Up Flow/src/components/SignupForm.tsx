import { useState } from 'react';
import { ChevronRight, ChevronLeft, Check } from 'lucide-react';
import { SocialButtons } from './SocialButtons';

type FormData = {
  fullName: string;
  email: string;
  password: string;
  company: string;
  role: string;
};

const STEPS = [
  { id: 1, title: 'Account Info', fields: ['fullName', 'email'] },
  { id: 2, title: 'Security', fields: ['password'] },
  { id: 3, title: 'Profile', fields: ['company', 'role'] }
];

export function SignupForm() {
  const [currentStep, setCurrentStep] = useState(1);
  const [formData, setFormData] = useState<FormData>({
    fullName: '',
    email: '',
    password: '',
    company: '',
    role: ''
  });

  const handleChange = (field: keyof FormData, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const handleNext = () => {
    if (currentStep < STEPS.length) {
      setCurrentStep(currentStep + 1);
    } else {
      handleSubmit();
    }
  };

  const handleBack = () => {
    if (currentStep > 1) {
      setCurrentStep(currentStep - 1);
    }
  };

  const handleSubmit = () => {
    console.log('Form submitted:', formData);
    alert('Account created successfully! 🎉');
  };

  const isStepValid = () => {
    const currentFields = STEPS[currentStep - 1].fields;
    return currentFields.every(field => formData[field as keyof FormData].trim() !== '');
  };

  return (
    <div className="w-full max-w-md">
      {/* Logo/Brand */}
      <div className="mb-8 text-center">
        <h1 className="text-3xl mb-2">Create your account</h1>
        <p className="text-gray-600">Join us and start your journey today</p>
      </div>

      {/* Progress Steps */}
      <div className="mb-8">
        <div className="flex items-center justify-between mb-2">
          {STEPS.map((step, index) => (
            <div key={step.id} className="flex items-center flex-1">
              {/* Step Circle */}
              <div className="flex flex-col items-center">
                <div
                  className={`w-10 h-10 rounded-full flex items-center justify-center transition-all duration-300 ${
                    currentStep > step.id
                      ? 'bg-green-500 text-white'
                      : currentStep === step.id
                      ? 'bg-purple-600 text-white ring-4 ring-purple-200'
                      : 'bg-gray-200 text-gray-500'
                  }`}
                >
                  {currentStep > step.id ? (
                    <Check className="w-5 h-5" />
                  ) : (
                    <span>{step.id}</span>
                  )}
                </div>
                <span className={`text-xs mt-2 ${currentStep === step.id ? 'text-purple-600' : 'text-gray-500'}`}>
                  {step.title}
                </span>
              </div>
              
              {/* Connector Line */}
              {index < STEPS.length - 1 && (
                <div className="flex-1 h-1 mx-2 mb-6">
                  <div
                    className={`h-full rounded transition-all duration-300 ${
                      currentStep > step.id ? 'bg-green-500' : 'bg-gray-200'
                    }`}
                  />
                </div>
              )}
            </div>
          ))}
        </div>
      </div>

      {/* Social Sign In (only on first step) */}
      {currentStep === 1 && (
        <div className="mb-6">
          <SocialButtons />
          
          <div className="relative my-6">
            <div className="absolute inset-0 flex items-center">
              <div className="w-full border-t border-gray-300" />
            </div>
            <div className="relative flex justify-center text-sm">
              <span className="px-4 bg-white text-gray-500">Or continue with email</span>
            </div>
          </div>
        </div>
      )}

      {/* Form Fields */}
      <form onSubmit={(e) => { e.preventDefault(); handleNext(); }} className="space-y-4">
        {/* Step 1: Account Info */}
        {currentStep === 1 && (
          <>
            <div>
              <label htmlFor="fullName" className="block text-sm mb-2 text-gray-700">
                Full Name
              </label>
              <input
                id="fullName"
                type="text"
                value={formData.fullName}
                onChange={(e) => handleChange('fullName', e.target.value)}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all"
                placeholder="John Doe"
                required
              />
            </div>
            <div>
              <label htmlFor="email" className="block text-sm mb-2 text-gray-700">
                Email Address
              </label>
              <input
                id="email"
                type="email"
                value={formData.email}
                onChange={(e) => handleChange('email', e.target.value)}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all"
                placeholder="john@example.com"
                required
              />
            </div>
          </>
        )}

        {/* Step 2: Security */}
        {currentStep === 2 && (
          <div>
            <label htmlFor="password" className="block text-sm mb-2 text-gray-700">
              Password
            </label>
            <input
              id="password"
              type="password"
              value={formData.password}
              onChange={(e) => handleChange('password', e.target.value)}
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all"
              placeholder="••••••••"
              required
              minLength={8}
            />
            <p className="text-xs text-gray-500 mt-2">
              Must be at least 8 characters long
            </p>
          </div>
        )}

        {/* Step 3: Profile */}
        {currentStep === 3 && (
          <>
            <div>
              <label htmlFor="company" className="block text-sm mb-2 text-gray-700">
                Company Name
              </label>
              <input
                id="company"
                type="text"
                value={formData.company}
                onChange={(e) => handleChange('company', e.target.value)}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all"
                placeholder="Acme Inc."
                required
              />
            </div>
            <div>
              <label htmlFor="role" className="block text-sm mb-2 text-gray-700">
                Your Role
              </label>
              <select
                id="role"
                value={formData.role}
                onChange={(e) => handleChange('role', e.target.value)}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all bg-white"
                required
              >
                <option value="">Select your role</option>
                <option value="developer">Developer</option>
                <option value="designer">Designer</option>
                <option value="manager">Manager</option>
                <option value="other">Other</option>
              </select>
            </div>
          </>
        )}

        {/* Navigation Buttons */}
        <div className="flex gap-3 pt-4">
          {currentStep > 1 && (
            <button
              type="button"
              onClick={handleBack}
              className="flex items-center justify-center gap-2 px-6 py-3 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
            >
              <ChevronLeft className="w-4 h-4" />
              Back
            </button>
          )}
          
          <button
            type="submit"
            disabled={!isStepValid()}
            className="flex-1 flex items-center justify-center gap-2 px-6 py-3 bg-purple-600 text-white rounded-lg hover:bg-purple-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
          >
            {currentStep === STEPS.length ? 'Create Account' : 'Continue'}
            {currentStep < STEPS.length && <ChevronRight className="w-4 h-4" />}
          </button>
        </div>
      </form>

      {/* Sign In Link */}
      <p className="text-center text-sm text-gray-600 mt-6">
        Already have an account?{' '}
        <a href="#" className="text-purple-600 hover:text-purple-700">
          Sign in
        </a>
      </p>
    </div>
  );
}
