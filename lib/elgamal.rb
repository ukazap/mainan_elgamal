require 'prime'

module Elgamal
  module Kunci
    module_function
    def generate(p)
      # Pilih sembarang bilangan prima p (p dapat di-share di antara anggota kelompok)
      raise(ArgumentError, "#{p} bukan bilangan prima") unless Prime.prime? p

      # Pilih dua buah bilangan acak, g dan x, dengan syarat g < p dan 1 <= x <= p – 2
      g, x = nil
      until g != x
        g = rand 1..(p-1)
        x = rand 1..(p-2)
      end

      # Hitung y = g^x mod p
      y = (g**x) % p

      {:publik => {y:y, g:g, p:p}, :privat => {x:x, p:p} }
    end

    # contoh generate:
    #   kunci = Elgamal::Kunci.generate 234
    #   puts kunci
  end

  module Pesan
    module_function
    def enkripsi(plaintext, publik)
      y, g, p = publik[:y], publik[:g], publik[:p]

      # Pilih bilangan acak k, di mana 1 <= k <= p – 2
      k = rand 1..(p-1)

      # Hitung a dan b (pasangan ciphertext)
      a = (g**k) % p
      b = (y**k) * plaintext % p

      # kirim
      [a, b]
    end

    # contoh enkripsi:
    #   plaintext = 42
    #   ciphertext = Elgamal::Pesan.enkripsi(plaintext, kunci[:publik])
    #   puts "#{plaintext} => #{ciphertext}"

    def dekripsi(ciphertext, privat)
      # Alice menerima ciphertext (a, b)
      a, b = ciphertext

      # kemudian mendekripsi menggunakan kunci privat x
      x, p = privat[:x], privat[:p]
      satu_per_a_pangkat_x = a**(p-1-x) % p
      dekripsi = (b * satu_per_a_pangkat_x) % p
    end

    # contoh dekripsi:
    #   plaintext2 = Elgamal::Pesan.dekripsi(ciphertext, kunci[:privat])
    #   puts "#{ciphertext} => #{plaintext2}"
  end
end