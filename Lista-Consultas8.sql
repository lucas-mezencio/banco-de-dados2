
create or replace function atualizar_ativos_f1()
	returns trigger as
$BODY$
declare 
	l_ativo_agencia float;
	l_nome_agencia character varying;
	cursor_relatorio cursor for select nome_agencia, sum(saldo_conta)
	from conta group by nome_agencia;
begin
 	open cursor_relatorio;
	 	loop
		 	fetch cursor_relatorio into l_nome_agencia, l_ativo_agencia;
		 	if found then
		 		if l_ativo is null then l_ativo_agencia = 0; end if;
		 		update agencia set ativo_agencia = l_ativo_agencia
		 		where nome_agencia = l_nome_agencia;
		 	end if;
		 if not found then exit; end if;
	 	end loop;
 	close cursor_relatorio;
 	return null;	
end; $BODY$
language plpgsql volatile cost 100;
alter function atualizar_ativos_f1() owner to aluno;


create trigger trigger_atualiza_ativos_f1
after update on conta
for each statement execute procedure atualizar_ativos_f1();

drop trigger if exists trigger_atualiza_ativos_f1 on conta;

update agencia set ativo_agencia = 0;


select * from agencia;



-- segunda forma de fazer

create or replace function atualizar_ativos_f2()
returns trigger as 
$body$
declare 
	l_ativo_agencia float;
	l_nome_agencia character varying;
	cursor_relatorio cursor for select nome_agencia, sum(saldo_conta)
	from conta
	group by nome_agencia;

begin
	raise notice 'função que recebe argumento %', tg_argv[0];
	open cursor_relatorio;
		loop
			fetch cursor_relatorio into l_nome_agencia, l_ativo_agencia;
			if found then 
				if l_ativo_agencia is null then l_ativo_agencia = 0; end if;
				update agencia set ativo_agencia = l_ativo_agencia
					where nome_agencia = l_nome_agencia;
			end if;
			if not found then exit; end if;
		end loop;
	close cursor_relatorio;
	return null;
end;
$body$
language plpgsql volatile cost 100;
alter function atualizar_ativos_f2() owner to aluno;
















































--IMPLEMENTE UM GATILHO (TRIGGER) QUE ATUALIZE A TABELA CONTA, PARA O CAMPO SALDO_CONTA, 
--SEMPRE QUE UMA NOVA LINHA FOR INSERIDA NA TABELA DE DEPÓSITO OU EMPRÉSTIMO.

