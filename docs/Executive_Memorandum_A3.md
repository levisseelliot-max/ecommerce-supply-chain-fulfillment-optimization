# A3 EXECUTIVE MEMORANDUM

## Brazilian E-Commerce Fulfillment Diagnostic & Margin Recovery Strategy

**TO:** Executive Committee

**FROM:** Elliot Levisse

**DATE:** August 24, 2026

**SUBJECT:** Brazilian E-Commerce Fulfillment & Margin Recovery Strategy

**CLASSIFICATION:** Internal — Strategic

---

# 1. Executive Decision

**Decision requested:** Approve a **$35,000 CapEx investment** to launch a Recife 3PL pilot, integrate dynamic carrier routing, and remediate high-risk merchants.

Olist currently generates **$13.22M GMV across 96,469 orders**, but fulfillment friction is suppressing service performance and margin. Enterprise **OTIF is 92.15%**, with an estimated **$246,350 annual P&L leakage**.

The diagnostic identifies a concentrated opportunity: **inter-state logistics account for 75.4% ($185,735) of total leakage**, despite representing 64.2% of shipment volume.

### Target Outcome

Raise enterprise OTIF from **92.15% → 96.50% within 9 months**, while recovering an estimated **$151,350 of annual net margin contribution**.

| **CURRENT STATE** |   **ROOT CAUSE**  |              **INTERVENTION**              | **TARGET STATE** |   **VALUE CREATION**  |
| :---------------: | :---------------: | :----------------------------------------: | :--------------: | :-------------------: |
|  **92.15% OTIF**  | **$246k leakage** | **3PL Hubs + Routing + Merchant Controls** |  **96.50% OTIF** | **+$151k net margin** |

**Executive recommendation:** Proceed with the pilot because the leakage is concentrated, operationally addressable, and measurable through a defined 9-month OTIF recovery program.

---

# 2. Problem Definition — Where Margin Is Being Lost

The root-cause analysis indicates that the primary constraint is **not merchant fulfillment speed**, but **middle- and last-mile transportation performance**, particularly on inter-state corridors.

### Network Diagnosis

* **Intra-state shipments — 35.8% of volume**

  * **4.72 days transit / 7.88 days total lead time**
  * Relatively efficient and lower risk.
  * No major structural intervention required.

* **Inter-state shipments — 64.2% of volume**

  * **11.69 days transit**, approximately **148% longer** than intra-state transit.
  * Generates **$185,735, or 75.4% of total estimated leakage**.
  * Represents the primary margin-recovery opportunity.

* **Geographic concentration**

  * More than **70% of shipments originate in São Paulo**.
  * The network therefore relies heavily on long-haul transportation into the Northeast and other distant regions.
  * Extreme examples include transit times of approximately **26.4 days to Roraima**, creating disproportionate OTIF and penalty exposure.

### Executive Diagnosis

> **The network is optimized around origin concentration rather than customer proximity.**
> The resulting long-haul dependency makes inter-state shipments structurally slower, less reliable, and more expensive.

---

# 3. Strategic Response — Three Focused Levers

## Pillar 1 — Forward-Deployed 3PL Hubs

**Pilot locations:** Recife and Salvador

Pre-position the highest-volume / highest-value **20% of SKUs** in Northeastern fulfillment hubs.

**Mechanism**

* Move selected demand closer to customers.
* Reduce dependence on São Paulo-origin long-haul transport.
* Prioritize SKUs with sufficient Northeast demand density to justify local inventory.

**Expected impact**

* Reduce selected transit times from approximately **18–26 days to <4.5 days**.
* Estimated **$68,000 annual penalty recovery**.

**Pilot gate:** Scale only if the hub demonstrates sustained OTIF improvement and positive unit economics after storage and handling costs.

---

## Pillar 2 — Dynamic Multi-Carrier Allocation

Deploy a **routing / carrier-allocation API** that dynamically assigns shipments using recent carrier performance rather than static routing rules.

**Decision variables**

* Trailing OTIF
* Lane-level transit performance
* SLA compliance
* Cost per shipment
* Capacity availability

Introduce **SLA-based carrier clawbacks** to align commercial incentives with service outcomes.

**Expected impact**

* Reduce carrier-related service failures.
* Mitigate approximately **$48,350 in customer churn-related leakage**.

---

## Pillar 3 — High-Risk Merchant Remediation

Create a targeted performance-management program for merchants contributing disproportionately to fulfillment failures.

**Controls**

* **48-hour dispatch trigger**
* Buy-box / visibility incentives for merchants achieving **≥95% OTIF**
* Progressive throttling for merchants below **90% OTIF**
* Weekly exception reporting for high-risk accounts

**Expected impact**

* Reduce merchant-driven fulfillment failures.
* Recover approximately **$35,000 in annual leakage**.

---

# 4. Financial Case

| **Metric**                     |   **Amount** | **Management Interpretation**                |
| :----------------------------- | -----------: | :------------------------------------------- |
| Upfront CapEx                  |  **$35,000** | 3PL setup + routing/API integration          |
| Annual OpEx                    |  **$42,000** | Storage + handling + ongoing operating costs |
| Gross annualized recovery      | **$193,350** | Avoided penalties + churn + merchant leakage |
| Net annualized margin recovery | **$151,350** | Gross recovery less annual OpEx              |
| Target OTIF improvement        | **+4.35 pp** | 92.15% → 96.50%                              |
| Target implementation horizon  | **9 months** | Pilot → optimization → scale                 |

### Investment Logic

The program converts a recurring **$246k leakage problem** into a targeted operational recovery program requiring only **$35k of upfront investment**.

The investment case should be presented using a clearly defined ROI convention:

**Steady-state return on CapEx = $151,350 / $35,000 = 432%**

However, **this is not the same as first-year ROI**, because the program also carries **$42,000 of annual OpEx** and the benefits are expected to ramp over nine months.

**Therefore, the previously stated “332% First-Year ROI / 2.8-month payback” should not be used without an explicit calculation methodology and benefit ramp.**

For Executive Committee approval, finance should validate:

1. Benefit ramp by month;
2. CapEx vs. OpEx classification;
3. Whether the $193,350 gross recovery is fully additive;
4. Timing of recovered margin;
5. Final first-year cash payback.

---

# 5. 9-Month Execution Roadmap

| **Phase**       | **Timing** | **Primary Deliverables**                                          | **Success Gate**           |
| :-------------- | :--------: | :---------------------------------------------------------------- | :------------------------- |
| **1. Mobilize** |    M0–M1   | Contract Recife 3PL; define SKU/lane scope; baseline carrier KPIs | Pilot operational          |
| **2. Launch**   |    M2–M3   | Hub inventory deployment; routing integration; merchant alerts    | ≥93.5% pilot OTIF          |
| **3. Optimize** |    M4–M6   | Carrier reallocation; SKU tuning; merchant enforcement            | ≥95% pilot OTIF            |
| **4. Scale**    |    M7–M9   | Expand winning lanes/SKUs; institutionalize controls              | **≥96.5% enterprise OTIF** |

---

# 6. Governance & KPIs

The program should be managed through a weekly executive scorecard.

### Primary KPI

**Enterprise OTIF: 92.15% → 96.50%**

### Operational Drivers

* Inter-state transit days
* Dispatch time
* Carrier-level OTIF
* Lane-level OTIF
* Hub fulfillment share
* Merchant OTIF

### Financial Outcomes

* Penalty leakage
* Churn-related leakage
* Merchant-driven leakage
* Gross recovery
* Incremental OpEx
* Net margin recovery

### Guardrails

* Cost per order
* Inventory days at hub
* Stockout rate
* Cancellation rate
* Customer experience / complaint rate

---

# 7. Risks & Mitigations

| **Risk**                            | **Potential Impact**                | **Mitigation**                                         |
| :---------------------------------- | :---------------------------------- | :----------------------------------------------------- |
| Hub inventory over-allocation       | Working-capital drag / obsolescence | Start with top 20% SKUs and demand thresholds          |
| Carrier switching disrupts capacity | Short-term service degradation      | Use trailing OTIF + capacity constraints               |
| Merchant resistance                 | Limited dispatch improvement        | Incentives + progressive throttling                    |
| Routing API underperforms           | Limited carrier optimization        | Pilot on selected lanes before network-wide deployment |
| Recovery assumptions overstated     | ROI dilution                        | Finance validation + monthly benefit tracking          |

---

# 8. Action Required

### **1 — Approve $35,000 CapEx**

Authorize Supply Chain and Technology to contract the **Recife 3PL pilot** and complete routing/API integration.

### **2 — Authorize Merchant Intervention**

Authorize the Supply Chain / Marketplace teams to implement the **48-hour dispatch trigger, ≥95% OTIF incentive, and <90% OTIF throttling framework**.

### **3 — Establish Executive Governance**

Mandate a **weekly OTIF and margin-recovery scorecard**, with a formal scale / stop decision at Month 6.

---

## Executive Conclusion

**The issue is concentrated, measurable, and operationally addressable.**

Inter-state logistics generate **75.4% of identified leakage**, making network decentralization and carrier optimization the highest-priority interventions. A targeted Recife pilot, supported by dynamic routing and merchant performance controls, provides a low-CapEx path to test the hypothesis before committing to broader network expansion.

**Recommendation: APPROVE the $35,000 pilot and launch immediately, subject to Finance validation of the first-year ROI and benefit-ramp assumptions.**
