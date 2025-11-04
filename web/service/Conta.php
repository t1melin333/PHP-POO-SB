<?php

require_once 'Titular.php';
abstract class Conta{
    protected int $id;
    protected Titular $titular;
    protected float $saldo;
    protected float $limite;


    public function setId(int $id): void
    {
        if ($id <= 0)
        {
            throw new Exception("O número da conta deve ser positivo.");
        }
        $this->id = $id;
    }

    public function getId(): int
    {
        return $this->id;
    }

    public function setTitular(Titular $titular): void
    {        
        $this->titular = $titular;
    }

    public function getTitular(): Titular
    {
        return $this->titular;
    }

    public function getSaldo(): float
    {
        return $this->saldo;
    }

    public function setLimite(float $limite): void
    {
        if ($limite < 0)
        {
            throw new Exception("O limite não pode ser negativo.");
        }
        $this->limite = $limite;
    }
    public function getLimite(): float
    {
        return $this->limite;
    }
    public abstract function Depositar(float $valor): void;
    public abstract function Sacar (float $valor): void;

    public function __toString()
    {
        return "Conta número: {$this->id}, Titular: {$this->titular->getNome()}, Saldo: {$this->"
    }



}