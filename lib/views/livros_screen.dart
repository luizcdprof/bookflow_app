import 'package:flutter/material.dart';
import '../models/livro_model.dart';
import '../services/auth_service.dart';
import '../services/livro_service.dart';
import '../widgets/livro_form_dialog.dart';

class LivrosScreen extends StatefulWidget {
  const LivrosScreen({super.key});

  @override
  State<LivrosScreen> createState() => _LivrosScreenState();
}

class _LivrosScreenState extends State<LivrosScreen> {
  late Future<List<LivroModel>> _livrosFuture;
  final _searchController = TextEditingController();

  bool get isBibliotecario => AuthService.currentUser?.user.isBibliotecario ?? false;

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  void _carregarLivros() {
    setState(() {
      _livrosFuture = LivroService.getLivros(search: _searchController.text.trim());
    });
  }

  Future<void> _abrirFormulario([LivroModel? livro]) async {
    final resultado = await showDialog<LivroModel>(
      context: context,
      builder: (_) => LivroFormDialog(livro: livro),
    );

    if (resultado != null) {
      try {
        if (livro == null) {
          await LivroService.createLivro(resultado);
          _mostrarSnackBar('Livro cadastrado com sucesso!');
        } else {
          await LivroService.updateLivro(livro.id!, resultado);
          _mostrarSnackBar('Livro atualizado com sucesso!');
        }
        _carregarLivros();
      } catch (e) {
        _mostrarSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
      }
    }
  }

  Future<void> _deletarLivro(LivroModel livro) async {
    final confirma = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente remover o livro "${livro.titulo}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirma == true && livro.id != null) {
      try {
        await LivroService.deleteLivro(livro.id!);
        _mostrarSnackBar('Livro removido com sucesso!');
        _carregarLivros();
      } catch (e) {
        _mostrarSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
      }
    }
  }

  void _mostrarSnackBar(String mensagem, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Acervo de Livros', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sair',
            onPressed: () {
              AuthService.logout();
              // Redireciona de volta para a tela de login limpando a pilha de telas
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Campo de Busca
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por título, autor ou ISBN...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    _searchController.clear();
                    _carregarLivros();
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (_) => _carregarLivros(),
            ),
            const SizedBox(height: 20),

            // Lista de Livros
            Expanded(
              child: FutureBuilder<List<LivroModel>>(
                future: _livrosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum livro encontrado.'));
                  }

                  final livros = snapshot.data!;
                  return ListView.builder(
                    itemCount: livros.length,
                    itemBuilder: (context, index) {
                      final livro = livros[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: livro.disponivel ? Colors.green.shade100 : Colors.red.shade100,
                            child: Icon(
                              livro.disponivel ? Icons.check_rounded : Icons.bookmark_remove_rounded,
                              color: livro.disponivel ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(livro.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${livro.autor} • ${livro.anoPublicacao} (ISBN: ${livro.isbn})'),
                          trailing: isBibliotecario
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_rounded, color: Colors.blue),
                                      onPressed: () => _abrirFormulario(livro),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                                      onPressed: () => _deletarLivro(livro),
                                    ),
                                  ],
                                )
                              : Chip(
                                  label: Text(livro.disponivel ? 'Disponível' : 'Indisponível'),
                                  backgroundColor: livro.disponivel ? Colors.green.shade50 : Colors.red.shade50,
                                ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isBibliotecario
          ? FloatingActionButton.extended(
              onPressed: () => _abrirFormulario(),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Novo Livro'),
            )
          : null,
    );
  }
}