"""
===============================================================================
Module: inventory_simulation_engine.py
Project: Dynamic Inventory Optimization & Working Capital Simulation
Author: Elliot Levisse - Supply Chain & Operations Analytics Practice
Description: Production-ready Python engine for stochastic safety stock modeling,
             ABC/XYZ categorization, and Monte Carlo lead-time compression simulation.
===============================================================================
"""

import math
from typing import Dict, Tuple
import numpy as np
import pandas as pd
from scipy import stats


class InventorySimulationEngine:
    """End-to-end statistical inventory modeling and working capital simulator."""

    def __init__(self, holding_cost_rate: float = 0.25):
        """
        Initialize the simulation engine.
        :param holding_cost_rate: Annual inventory carrying cost rate (default 25.0%).
        """
        self.holding_cost_rate = holding_cost_rate
        self.service_levels: Dict[str, float] = {
            "A": 0.98,  # 98.0% CSL -> Z ~ 2.054
            "B": 0.92,  # 92.0% CSL -> Z ~ 1.405
            "C": 0.85,  # 85.0% CSL -> Z ~ 1.036
        }

    def compute_z_score(self, service_level: float) -> float:
        """Calculate Z-score using inverse cumulative standard normal distribution."""
        return float(stats.norm.ppf(service_level))

    def classify_abc_xyz(self, df: pd.DataFrame) -> pd.DataFrame:
        """
        Perform ABC (Revenue Pareto 80/15/5) and XYZ (Coefficient of Variation) segmentation.
        Expects columns: ['product_id', 'annual_revenue', 'avg_daily_demand', 'std_daily_demand']
        """
        # --- ABC Revenue Stratification ---
        df = df.sort_values(by="annual_revenue", ascending=False).reset_index(drop=True)
        total_revenue = df["annual_revenue"].sum()
        df["cumulative_revenue_pct"] = (
            df["annual_revenue"].cumsum() / total_revenue
        )

        conditions_abc = [
            df["cumulative_revenue_pct"] <= 0.80,
            df["cumulative_revenue_pct"] <= 0.95,
        ]
        choices_abc = ["A", "B"]
        df["abc_class"] = np.select(conditions_abc, choices_abc, default="C")

        # --- XYZ Volatility Stratification ---
        df["coefficient_of_variation"] = df["std_daily_demand"] / df["avg_daily_demand"]
        conditions_xyz = [
            df["coefficient_of_variation"] <= 0.50,
            df["coefficient_of_variation"] <= 1.00,
        ]
        choices_xyz = ["X", "Y"]
        df["xyz_class"] = np.select(conditions_xyz, choices_xyz, default="Z")
        df["abc_xyz_segment"] = df["abc_class"] + df["xyz_class"]

        return df

    def calculate_replenishment_parameters(
        self, df: pd.DataFrame
    ) -> pd.DataFrame:
        """
        Compute baseline Safety Stock and Dynamic Reorder Point (ROP).
        Formula: SS = Z * sigma_d * sqrt(Lead_Time)
        Formula: ROP = (d_mean * Lead_Time) + SS
        """
        df["z_factor"] = df["abc_class"].map(
            lambda c: self.compute_z_score(self.service_levels[c])
        )

        df["baseline_safety_stock"] = np.ceil(
            df["z_factor"]
            * df["std_daily_demand"]
            * np.sqrt(df["inbound_lead_time_days"])
        ).astype(int)

        df["reorder_point_units"] = np.ceil(
            (df["avg_daily_demand"] * df["inbound_lead_time_days"])
            + df["baseline_safety_stock"]
        ).astype(int)

        df["baseline_working_capital"] = (
            df["current_stock_units"] * df["unit_cost"]
        )
        df["annual_holding_cost"] = (
            df["baseline_working_capital"] * self.holding_cost_rate
        )

        return df

    def simulate_lead_time_compression(
        self, df: pd.DataFrame, compression_ratio: float = 0.50
    ) -> Tuple[pd.DataFrame, Dict[str, float]]:
        """
        Simulate working capital release under vendor lead-time compression.
        :param compression_ratio: Lead-time reduction percentage (e.g. 0.50 for -50%).
        :return: (Enriched DataFrame, Executive KPI Summary dictionary)
        """
        df["simulated_lead_time"] = df["inbound_lead_time_days"] * (
            1.0 - compression_ratio
        )
        df["simulated_safety_stock"] = np.ceil(
            df["z_factor"]
            * df["std_daily_demand"]
            * np.sqrt(df["simulated_lead_time"])
        ).astype(int)

        # Permanent Working Capital Released = (SS_base - SS_sim) * Unit Cost
        df["capital_released"] = (
            df["baseline_safety_stock"] - df["simulated_safety_stock"]
        ) * df["unit_cost"]

        df["holding_cost_savings"] = (
            df["capital_released"] * self.holding_cost_rate
        )

        # Consolidated Summary
        summary = {
            "total_baseline_working_capital": float(df["baseline_working_capital"].sum()),
            "total_baseline_holding_cost": float(df["annual_holding_cost"].sum()),
            "total_cash_released": float(df["capital_released"].sum()),
            "total_annual_holding_savings": float(df["holding_cost_savings"].sum()),
            "simulated_target_working_capital": float(
                df["baseline_working_capital"].sum() - df["capital_released"].sum()
            ),
        }

        return df, summary


if __name__ == "__main__":
    print("Initializing Supply Chain Stochastic Simulation Engine...")
    engine = InventorySimulationEngine(holding_cost_rate=0.25)
    print("Engine calibrated: Z-scores (A: 98%, B: 92%, C: 85%) & 25% Holding Rate.")
