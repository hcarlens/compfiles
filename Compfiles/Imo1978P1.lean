/-
Copyright (c) 2024 The Compfiles Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: InternLM-MATH LEAN Formalizer v0.1
-/

import Mathlib.Tactic

import ProblemExtraction

problem_file { tags := [.NumberTheory] }

/-!
# International Mathematical Olympiad 1978, Problem 1

m and n are positive integers with m < n.
The last three decimal digits of 1978ᵐ are the same as the
last three decimal digits of 1978ⁿ.
Find m and n such that m + n has the least possible value.
-/

namespace Imo1978P1

determine solution : ℕ × ℕ := (3, 103)

abbrev ValidPair : ℕ × ℕ → Prop
| (m, n) => 1 ≤ m ∧ m < n ∧ (1978^m) % 1000 = (1978^n) % 1000

problem imo1978_p1 (m n : ℕ)
    (hmn : (m, n) = solution) :
    ValidPair (m, n) ∧
    (∀ m' n' : ℕ, ValidPair (m', n') → m + n ≤ m' + n') := by
  -- We follow the informal solution at
  -- https://prase.cz/kalva/imo/isoln/isoln781.html
  constructor
  · rw [hmn, solution, ValidPair]
    norm_num
  intro m' n' hmn'
  -- We require 1978^m'(1978^(n'-m') - 1) to be a multiple of 1000=8·125.
  dsimp only [ValidPair] at hmn'
  obtain ⟨h1, h2, h3⟩ := hmn'
  change _ ≡ _ [MOD 1000] at h3
  rw [Nat.modEq_iff_dvd] at h3
  push_cast at h3
  replace h3 : (1000:ℤ) ∣ 1978 ^ m' * (1978 ^ (n' - m') - 1) := by
    rw [mul_sub, mul_one]
    rwa [pow_mul_pow_sub 1978 (Nat.le_of_succ_le h2)]
  rw [show (1000 : ℤ) = 8 * 125 by norm_num] at h3

  -- So we must have 8 divides 1978^m',
  have h4 : (8 : ℤ) ∣ 1978 ^ m' := by
    replace h3 : (8:ℤ) ∣ 1978 ^ m' * (1978 ^ (n' - m') - 1) :=
      dvd_of_mul_right_dvd h3
    have h5 : IsCoprime (8 : ℤ) (1978 ^ (n' - m') - 1) := by
      rw [show (8 : ℤ) = 2 ^ 3 by norm_num]
      suffices H : IsCoprime (2 : ℤ) (1978 ^ (n' - m')- 1) from
        IsCoprime.pow_left H
      suffices H : ¬ (2:ℤ) ∣ (1978 ^ (n' - m') - 1) from
        (Prime.coprime_iff_not_dvd Int.prime_two).mpr H
      rw [Int.two_dvd_ne_zero]
      have h6 : 1 ≤ (1978 ^ (n' - m')) := Nat.one_le_pow' (n' - m') 1977
      rw [show (1978 : ℤ) = 2 * 989 by norm_num]
      have h7 : (((2:ℤ) * 989) ^ (n' - m')) % 2 = 0 := by
        rw [mul_pow]
        obtain ⟨c, hc⟩ : ∃ c, c = (n' - m') := exists_eq
        cases' c with c
        · omega
        · rw [←hc, pow_succ', mul_assoc]
          exact Int.mul_emod_right _ _
      rw [Int.sub_emod, h7]
      norm_num
    exact IsCoprime.dvd_of_dvd_mul_right h5 h3

  -- and hence m ≥ 3
  have h5 : 3 ≤ m' := by
    rw [show (1978 : ℤ) = 2 * 989 by norm_num] at h4
    rw [show (8 : ℤ) = 2 ^ 3 by norm_num] at h4
    rw [mul_pow] at h4
    have h6 : IsCoprime ((2:ℤ)^3) (989 ^ m') := by
      suffices H : IsCoprime (2:ℤ) (989 ^ m') from IsCoprime.pow_left H
      rw [Prime.coprime_iff_not_dvd Int.prime_two, Int.two_dvd_ne_zero]
      rw [←Int.odd_iff, Int.odd_pow]
      exact Or.inl ⟨494, rfl⟩
    replace h4 := IsCoprime.dvd_of_dvd_mul_right h6 h4
    obtain ⟨c, hc⟩ := h4
    have hc' := hc
    apply_fun (fun x => multiplicity 2 x) at hc
    have hf : multiplicity.Finite 2 (2 ^ 3 * c) := by
      apply multiplicity.finite_prime_left Int.prime_two
      simp only [Int.reducePow, ne_eq, mul_eq_zero, OfNat.ofNat_ne_zero, false_or]
      rintro rfl
      simp at hc'
    rw [multiplicity_mul Int.prime_two hf] at hc
    rw [multiplicity_pow_self (by norm_num) (by decide)] at hc
    rw [multiplicity_pow_self (by norm_num) (by decide)] at hc
    omega

  -- and 125 divides 1978^(n'-m') - 1.
  have h6 : 125 ∣ 1978^(n'-m') - 1 := by
    sorry
  sorry

end Imo1978P1
