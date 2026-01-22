import { useState } from 'react';
import { Header } from './Header';
import { BalanceCard } from './BalanceCard';
import { QuickStats } from './QuickStats';
import { GoalsProgress } from './GoalsProgress';
import { RecentTransactions } from './RecentTransactions';
import { BottomNavigation } from './BottomNavigation';
import { TransactionModal } from './TransactionModal';

export function HomeScreen() {
  const [showModal, setShowModal] = useState(false);
  const [modalType, setModalType] = useState<'income' | 'expense' | null>(null);
  const userName = "Sergio";

  const handleSwipe = (type: 'income' | 'expense') => {
    setModalType(type);
    setShowModal(true);
  };

  return (
    <div className="min-h-screen relative overflow-hidden">
      {/* Background Gradient - matching Swift design system */}
      <div 
        className="fixed inset-0 -z-10"
        style={{
          background: 'linear-gradient(180deg, #250000 0%, #000008 50%, #00454d 100%)'
        }}
      />
      
      {/* Main Content */}
      <div className="relative z-0 pb-24">
        {/* Header */}
        <Header userName={userName} />
        
        {/* Scrollable Content */}
        <div className="px-4 space-y-4">
          {/* Balance Card */}
          <BalanceCard />
          
          {/* Quick Stats (Ingresos y Gastos) */}
          <QuickStats />
          
          {/* Goals Progress */}
          <GoalsProgress />
          
          {/* Recent Transactions */}
          <RecentTransactions />
        </div>
      </div>
      
      {/* Bottom Navigation */}
      <BottomNavigation onSwipe={handleSwipe} />
      
      {/* Transaction Modal */}
      {showModal && modalType && (
        <TransactionModal 
          type={modalType} 
          onClose={() => setShowModal(false)} 
        />
      )}
    </div>
  );
}
