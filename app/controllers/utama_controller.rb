class UtamaController < ApplicationController
  def index
  end

  def key
    begin
      @kunci = Elgamal::Kunci.generate params[:p].to_i
    rescue Exception => e
      redirect_to root_url, alert: e.message
    end
  end

  def prima
    @prima = Prime.take(params[:berapa].to_i)
  end

  def enkripsi
    @pesan = params[:pesan]
    @kunci_publik = {
      y: params[:y].to_i,
      g: params[:g].to_i,
      p: params[:p].to_i
    }

    a, b = "", ""
    @pesan.each_byte do |byte|
      pair = Elgamal::Pesan.enkripsi(byte, @kunci_publik)
      a << pair[0]
      b << pair[1]
    end

    @ciphertext = a + b
  end

  def dekripsi
    kunci_privat = {
      x: params[:x].to_i,
      p: params[:p].to_i
    }

    ciphertext = params[:ciphertext]

    pairs = []
    ciph_a, ciph_b = ciphertext.scan(/.{1,#{ciphertext.size/2}}/)
    ciph_a.chars.each_with_index do |a, i|
      pairs << [a.ord, ciph_b[i].ord]
    end

    pairs.map! do |pair|
      Elgamal::Pesan.dekripsi(pair, kunci_privat).chr
    end

    @plaintext = pairs.join
  end
end
