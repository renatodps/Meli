



----Query 1
---usuarios que cumplan años el día de hoy cuya cantidad de ventas realizadas en enero 2020 sea superior a 1500
select    c.name
		, count(o.order_id) as [ventas realizadas]
from [order] o
inner join customer c
on c.customer_id = o.customer_id 
   	
where c.fecha_nascimiento = getdate() and
	 year(o.fecha_pedido) = 2020 and 
	 month(o.fecha_pedido) = 1
group by  c.name
		, o.valor
having count (o.order_id) > 1500 



----Query 2
-- Por cada mes del 2020, se solicita el top 5 de usuarios que más vendieron($) en la categoría Celulares. 
--Se requiere el mes y año de análisis, nombre y apellido del vendedor, cantidad de ventas realizadas, cantidad de productos vendidos y el monto total transaccionado
   with vendascte as (
    select   
        month(o.fecha_pedido) as mes,
        year(o.fecha_pedido) as ano,
        c.nombre,
        c.apelido,
        count(o.order_id) as quantidade_vendas,
        sum(o.cantidad) as quantidade_produtos,
        sum(i.preco * o.cantidad) as valor_total,
        rank() over (partition by year(o.fecha_pedido), month(o.fecha_pedido) order by sum(o.valor) desc) as classificacao
    from [order] o
    inner join customer c on c.customer_id = o.customer_id 
    inner join item i on i.item_id = o.item_id
    inner join category cat on cat.category_id = i.category_id
    where	year(o.fecha_pedido) = 2020 and 
			cat.category_descripcion = 'celulares y smartphones'
    group by 
        year(o.fecha_pedido),
        month(o.fecha_pedido),
        c.nombre,
        c.apelido
)
select *
from vendascte
where classificacao <= 5;

----query 3

---criação da tabela de histórico
 create table item_history (
    item_id int primary key, 
    preco decimal(10,2),
    status varchar(50),
    fecha_cierre date default cast(getdate() as date) -- data de fechamento do dia
);


------criação da procedure
---atualizar_item_history

create procedure sp_atualizar_item_history
as
begin
    set nocount on;

    -- atualiza os registros do dia atual na tabela de histórico
    merge into item_history as target
    using (select 
                i.item_id, 
                i.valor, 
                i.status,
                cast(getdate() as date) as fecha_cierre
           from item i) as source
    on target.item_id = source.item_id and target.fecha_cierre = source.fecha_cierre
    --quando encontrou o registro pelo item_id faz update
	when matched then 
        update set target.preco = source.preco, target.status = source.status
   --quando não encontrou o registro pelo item_id faz insert
    when not matched then
        insert (item_id, preco, status, fecha_cierre)
        values (source.item_id, source.preco, source.status, source.fecha_cierre);

    print 'histórico atualizado com sucesso!';
end;




