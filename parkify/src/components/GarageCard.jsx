import React from 'react';
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card"

const GarageCard = ({ garage }) => (
  <Card className="hover:shadow-lg transition-shadow">
    <CardHeader>
      <CardTitle>{garage.title}</CardTitle>
    </CardHeader>
    <CardContent>
      <p className="text-gray-600 italic mb-2">{garage.address}</p>
      <div className="space-y-2">
        <p className="flex justify-between">
          <span className="font-medium">Status:</span> 
          <span className={garage.status === "High Traffic" ? "text-red-500" : "text-green-500"}>
            {garage.status}
          </span>
        </p>
        <p className="flex justify-between">
          <span className="font-medium">Parking Spots:</span> 
          <span>{garage.spots}</span>
        </p>
      </div>
    </CardContent>
  </Card>
);

export default GarageCard;
