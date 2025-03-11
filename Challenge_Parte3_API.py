import requests
import pandas as pd
import json

# Definição dos termos de pesquisa
search_terms = ["chromecast", "google home", "apple tv", "amazon fire tv"]
limit_per_request = 50  # Máximo permitido por requisição
total_items = 150  # Número total de itens desejados por termo
base_url = "https://api.mercadolibre.com/sites/MLA/search"
item_base_url = "https://api.mercadolibre.com/items/"

# Função para buscar itens da API
def fetch_items(query, total_items=150):
    items = []
    offset = 0

    while len(items) < total_items:
        try:
            response = requests.get(base_url, params={"q": query, "limit": limit_per_request, "offset": offset})
            response.raise_for_status()  # Lança uma exceção para status codes de erro
            data = response.json()
            results = data.get("results", [])
            items.extend(results)

            if len(results) < limit_per_request:  # Se não houver mais itens, sair do loop
                break
            offset += limit_per_request
        except requests.RequestException as e:
            print(f"Erro na requisição para '{query}': {e}")
            break

    return items[:total_items]  # Garantir que não passe do limite desejado

# Função para buscar detalhes de um item
def fetch_item_details(item_id):
    try:
        response = requests.get(item_base_url + item_id)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        print(f"Erro ao buscar detalhes do item {item_id}: {e}")
        return None

# Coletar dados para cada termo de pesquisa
all_items_data = []

for term in search_terms:
    print(f"Buscando por {term}...")
    items = fetch_items(term, total_items)

    if items:
        print(f"Encontrados {len(items)} itens para '{term}'.")

        for item in items:
            item_id = item.get("id")
            if item_id:
                item_details = fetch_item_details(item_id)

                if item_details:
                    # Desnormalizar os dados do item e adicionar à lista
                    all_items_data.append({
                        "termo_pesquisa": term,
                        "item_id": item_id,
                        "titulo": item_details.get("title"),
                        "preco": item_details.get("price"),
                        "moeda": item_details.get("currency_id"),
                        "disponibilidade": item_details.get("available_quantity"),
                        "vendidos": item_details.get("sold_quantity"),
                        "condicao": item_details.get("condition"),
                        "link": item_details.get("permalink"),
                    })
                else:
                    print(f"Detalhes não encontrados para o item {item_id}.")
            else:
                print("ID do item não encontrado.")
    else:
        print(f"Nenhum item encontrado para '{term}'.")

# Criar um DataFrame e salvar os resultados
if all_items_data:
    df = pd.DataFrame(all_items_data)
    try:
        df.to_csv("mercadolivre_itens_detalhes.csv", index=False, encoding="utf-8-sig")
        print("Coleta concluída! Dados salvos em 'mercadolivre_itens_detalhes.csv'.")
    except Exception as e:
        print(f"Erro ao salvar o arquivo: {e}")
else:
    print("Nenhum dado coletado. Arquivo não gerado.")
