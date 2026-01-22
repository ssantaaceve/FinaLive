import { Bell } from 'lucide-react';

interface HeaderProps {
  userName: string;
}

export function Header({ userName }: HeaderProps) {
  return (
    <div className="px-4 pt-12 pb-6">
      <div className="flex items-center justify-between">
        {/* User Avatar */}
        <div className="w-12 h-12 rounded-full bg-gradient-to-br from-[#3DBB8F] to-[#2EA37A] flex items-center justify-center flex-shrink-0">
          <span className="text-white text-lg font-semibold">
            {userName.charAt(0).toUpperCase()}
          </span>
        </div>
        
        {/* Centered Greeting */}
        <div className="flex-1 text-center">
          <p className="text-[#8E8E93] text-sm">Hola,</p>
          <h1 className="text-white text-xl font-semibold">{userName}</h1>
        </div>
        
        {/* Notifications Bell */}
        <button 
          className="relative w-10 h-10 rounded-full flex items-center justify-center flex-shrink-0 backdrop-blur-xl border"
          style={{
            background: 'rgba(28, 28, 30, 0.6)',
            borderColor: 'rgba(255, 255, 255, 0.1)',
            boxShadow: '0 2px 12px rgba(0, 0, 0, 0.2), inset 0 1px 0 rgba(255, 255, 255, 0.08)'
          }}
        >
          <Bell className="w-5 h-5 text-white" />
          {/* Notification Badge */}
          <span 
            className="absolute top-1 right-1 w-2 h-2 rounded-full border-2"
            style={{
              background: '#FF5F5F',
              borderColor: '#000008',
              boxShadow: '0 0 8px rgba(255, 95, 95, 0.6)'
            }}
          />
        </button>
      </div>
    </div>
  );
}