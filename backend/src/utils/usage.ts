export interface UsageSnapshot {
  plan: string;
  dailyLimit: number;
  dailyUsed: number;
  minuteLimit: number;
  minuteUsed: number;
  providerConfigured: boolean;
  windowStartsAt: string;
}

/** Tracks provider request budgets so the free plan limits are never exceeded. */
export class UsageTracker {
  private dayKey = '';
  private minuteKey = '';
  private dailyUsed = 0;
  private minuteUsed = 0;

  constructor(
    private readonly dailyLimit: number,
    private readonly minuteLimit: number,
    private readonly providerConfigured: boolean,
    private readonly now: () => Date = () => new Date(),
  ) {}

  private keys(): { day: string; minute: string } {
    const date = this.now();
    return {
      day: date.toISOString().slice(0, 10),
      minute: date.toISOString().slice(0, 16),
    };
  }

  private rollover(): void {
    const { day, minute } = this.keys();
    if (day !== this.dayKey) {
      this.dayKey = day;
      this.dailyUsed = 0;
    }
    if (minute !== this.minuteKey) {
      this.minuteKey = minute;
      this.minuteUsed = 0;
    }
  }

  assertAllowed(): void {
    this.rollover();
    if (this.dailyUsed >= this.dailyLimit) {
      throw new Error('DAILY_LIMIT_EXCEEDED');
    }
    if (this.minuteUsed >= this.minuteLimit) {
      throw new Error('RATE_LIMIT_EXCEEDED');
    }
  }

  record(): void {
    this.rollover();
    this.dailyUsed += 1;
    this.minuteUsed += 1;
  }

  snapshot(plan: string): UsageSnapshot {
    this.rollover();
    return {
      plan,
      dailyLimit: this.dailyLimit,
      dailyUsed: this.dailyUsed,
      minuteLimit: this.minuteLimit,
      minuteUsed: this.minuteUsed,
      providerConfigured: this.providerConfigured,
      windowStartsAt: `${this.minuteKey}:00.000Z`,
    };
  }
}
