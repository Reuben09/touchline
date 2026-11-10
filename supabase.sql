begin;
create table if not exists public.touchline_offers (
  slug text primary key,
  title text not null,
  category text not null,
  value text not null,
  rules jsonb not null check (jsonb_typeof(rules) = 'array'),
  sort_order integer not null default 100,
  active boolean not null default false
);
alter table public.touchline_offers enable row level security;
revoke all on public.touchline_offers from anon, authenticated;
grant select on public.touchline_offers to anon, authenticated;
drop policy if exists "Read active offers" on public.touchline_offers;
create policy "Read active offers" on public.touchline_offers for select to anon, authenticated using (active);
insert into public.touchline_offers (slug,title,category,value,rules,sort_order,active) values
('welcome-match', 'Welcome Deposit Match', 'Welcome', '100% up to ₦25,000', '["Available to verified new customers on their first deposit of at least ₦1,000.","Opt in before depositing. Wager the bonus five times on pre-match bets at decimal odds of 1.80 or higher.","The bonus and any restricted winnings expire seven days after credit."]', 1, true),
('second-deposit', 'Second Deposit Boost', 'Welcome', '50% up to ₦10,000', '["Verified customers can opt in before their second deposit of at least ₦2,000.","Wager the bonus four times on settled pre-match singles at odds of 1.80 or higher.","Complete wagering within five days of credit."]', 2, true),
('acca-boost', 'Accumulator Boost', 'Football', 'Up to 25% extra', '["Place a cash accumulator with at least four football selections at odds of 1.40 or higher each.","Four winning legs earn 5% extra on net winnings. Add five percentage points per additional winning leg, up to 25%.","Void legs are removed before calculating the boost. The maximum boost is ₦20,000 per ticket."]', 3, true),
('acca-cover', 'One-Leg Acca Cover', 'Football', 'Up to ₦5,000 back', '["Opt in before placing a cash football accumulator with at least five selections at odds of 1.50 or higher each.","If exactly one selection loses and all others win, receive your stake back as a free bet, capped at ₦5,000.","Limited to the first qualifying ticket per day. Use the free bet within three days."]', 4, true),
('early-payout', 'Two-Goal Early Payout', 'Football', 'Two-goal lead', '["Place a pre-match cash single on a team to win in the 90-minute match-result market on a marked fixture.","If your team leads by two goals, the bet is paid as a winner even if the final result changes.","Maximum early payout is ₦50,000 per ticket. Abandoned fixtures and cashed-out bets are excluded."]', 5, true),
('live-token', 'Live Bet Token', 'Live', '₦1,000 free bet', '["Opt in and settle a cash in-play single of at least ₦5,000 at odds of 1.80 or higher.","The first eligible ticket per week earns a ₦1,000 free bet. The free-bet stake is excluded from returns.","Use the token on an in-play single at odds of 1.50 or higher within 72 hours."]', 6, true),
('weekend-reload', 'Weekend Reload', 'Reloads', '30% up to ₦7,500', '["Opt in before your first deposit of at least ₦2,500 between Friday 00:00 and Sunday 23:59 WAT.","Wager the credited bonus four times on settled pre-match bets at odds of 1.75 or higher.","Bonus wagering closes seven days after credit. One reload per weekend."]', 7, true),
('monday-cashback', 'Monday Sports Cashback', 'Reloads', '10% up to ₦5,000', '["Opt in before betting during the Monday-to-Sunday promotion week, measured in WAT.","Earn 10% of positive net cash losses on eligible settled sportsbook bets. Net loss is eligible stakes minus returns.","Credited as a free bet the following Monday when the reward reaches ₦200. Use within seven days."]', 8, true),
('basketball-boost', 'Basketball Treble Boost', 'Other sports', '15% extra', '["Place a cash treble on three pre-match basketball moneyline selections at odds of 1.50 or higher each.","If all three selections win, receive 15% extra on net winnings, capped at ₦10,000.","Void, pushed, and cashed-out selections disqualify the ticket. One boosted ticket per day."]', 9, true),
('tennis-protection', 'Tennis First-Set Cover', 'Other sports', 'Up to ₦3,000 back', '["Opt in before placing a cash pre-match singles match-winner bet at odds of 1.70 or higher on a marked fixture.","If your selection wins the first set but loses the completed match, get the stake back as a free bet, up to ₦3,000.","Retirements, walkovers and cash-outs are excluded. Use the free bet within 72 hours."]', 10, true)
on conflict (slug) do nothing;
commit;

