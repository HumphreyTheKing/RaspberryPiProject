import React, { useState } from 'react';
import GarageCard from './GarageCard';
import Map from './Map';

const ParkingApp = () => {
  const [loading, setLoading] = useState(true);

  const garages = [
    {
      title: "Cottage Grove Parking Garage",
      address: "1067 Cottage Grove Ave, Las Vegas, NV 89119",
      status: "High Traffic",
      spots: 540,
      position: { lat: 36.1112, lng: -115.1401 }
    },
    {
      title: "Tropicana Parking Garage",
      address: "12 Wilbur St, Las Vegas, NV 89119",
      status: "High Traffic",
      spots: 960,
      position: { lat: 36.103, lng: -115.1431 }
    },
    {
      title: "University Gateway Parking Garage",
      address: "1280 Dorothy Ave, Las Vegas, NV 89119",
      status: "Low Traffic",
      spots: 1023,
      position: { lat: 36.10342, lng: -115.136193 }
    }
  ];

  return (
    <div className="h-screen flex flex-col">
      <header className="bg-red-700/90 h-[50px]">
        <div className="container h-full ml-[10%]">
          <a href="#" className="h-full w-[100px] text-gray-100 flex items-center justify-center hover:bg-red-800">
            Parkify
          </a>
        </div>
      </header>

      <div className="flex flex-1 lg:flex-row flex-col">
        <div className="lg:w-2/3 p-4 h-[500px] lg:h-auto">
          <Map garages={garages} setLoading={setLoading} loading={loading} />
        </div>

        <div className="lg:w-1/3 p-4 overflow-y-auto">
          <div className="space-y-4">
            {garages.map((garage, index) => (
              <GarageCard key={index} garage={garage} />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default ParkingApp;
