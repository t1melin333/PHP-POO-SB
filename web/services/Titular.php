<?php 


class Titular{
    protected string $nome;
    protected string $cpf;
    protected string $endereco;

    public function __construct ($nome, $cpf, $endereco){
        $this->nome = $nome;
        $this->cpf = $cpf;
        $this->endereco = $endereco;
    }

    public function setNome($nome){
        if(strlen(trim($nome)) < 3){
            throw new InvalidArgumentException("O nome do titular considerado insuficiente.");
        }

        if(preg_match('/\d/', $nome)){
            throw new InvalidArgumentException("O nome do titular não deve conter números, apenas letras.");
        }

        $this->nome = $nome;
    }

    public function setCpf($cpf){
        if(strlen(trim($cpf)) != 11){
            throw new InvalidArgumentException("O CPF deve conter exatamente 11 caracteres númericos, sem contar traços e pontos.");
        }

        $this->cpf = $cpf;
    }

    public function setEndereco($endereco){
        if(is_null($endereco))
        {
            throw new InvalidArgumentException("O endereço não pode ser nulo.");
        }
        $this->endereco = $endereco;
    }

    public function getNome():string{
        return $this->nome;
    }
    public function getCpf():string{
        return $this->cpf;
    }
    public function getEndereco():string{
        return $this->endereco;
    }

    public function __toString(): string {
        return 'Nome: ' . $this->nome . ', CPF: ' . $this->cpf . ', Endereço: ' . $this->endereco;
    }

}