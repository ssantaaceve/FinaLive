import { useState, useEffect } from 'react';
import { CarouselPanel } from './CarouselPanel';
import { SignupForm } from './SignupForm';

export function SignupFlow() {
  return (
    <div className="min-h-screen flex flex-col md:flex-row">
      {/* Left Panel - Carousel */}
      <div className="md:w-1/2 lg:w-3/5 bg-gradient-to-br from-purple-600 to-blue-600 hidden md:block">
        <CarouselPanel />
      </div>
      
      {/* Right Panel - Signup Form */}
      <div className="w-full md:w-1/2 lg:w-2/5 bg-white flex items-center justify-center p-6 md:p-12">
        <SignupForm />
      </div>
    </div>
  );
}
