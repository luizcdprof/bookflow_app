import 'package:flutter/material.dart';
import '../models/livro_model.dart';
import '../widgets/custom_text_field.dart';

class LivroFormDialog extends StatefulWidget {
  final LivroModel? livro;

  const LivroFormDialog({super.key, this.livro});

  @override
  State<LivroFormDialog> createState() => _LivroFormDialogState();
}

class _LivroFormDialogState extends State<LivroFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _autorController;
  late TextEditingController _isbnController;
  late TextEditingController _anoController;
  bool _disponivel = true;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.livro?.titulo ?? '');
    _autorController = TextEditingController(text: widget.livro?.autor ?? '');
    _isbnController = TextEditingController(text: widget.livro?.isbn ?? '');
    _anoController = TextEditingController(text: widget.livro?.anoPublicacao.toString() ?? DateTime.now().year.toString());
    _disponivel = widget.livro?.disponivel ?? true;
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final novoLivro = LivroModel(
      id: widget.livro?.id,
      titulo: _tituloController.text.trim(),
      autor: _autorController.text.trim(),
      isbn: _isbnController.text.trim(),
      anoPublicacao: int.parse(_anoController.text),
      disponivel: _disponivel,
    );

    Navigator.of(context).pop(novoLivro);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.livro != null;

    return AlertDialog(
      title: Text(isEditing ? 'Editar Livro' : 'Novo Livro'),
      content: SingleChildScrollView(
        child: Container(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: _tituloController,
                  label: 'Título',
                  hint: 'Ex: Dom Casmurro',
                  prefixIcon: Icons.book_rounded,
                  validator: (v) => v == null || v.isEmpty ? 'Informe o título' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _autorController,
                  label: 'Autor',
                  hint: 'Ex: Machado de Assis',
                  prefixIcon: Icons.person_rounded,
                  validator: (v) => v == null || v.isEmpty ? 'Informe o autor' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _isbnController,
                  label: 'ISBN',
                  hint: 'Ex: 9788535902778',
                  prefixIcon: Icons.qr_code_rounded,
                  validator: (v) => v == null || v.isEmpty ? 'Informe o ISBN' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _anoController,
                  label: 'Ano de Publicação',
                  hint: 'Ex: 1899',
                  prefixIcon: Icons.calendar_today_rounded,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe o ano';
                    if (int.tryParse(v) == null) return 'Ano inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Disponível para Empréstimo'),
                  value: _disponivel,
                  onChanged: (val) => setState(() => _disponivel = val),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _salvar,
          child: Text(isEditing ? 'Atualizar' : 'Cadastrar'),
        ),
      ],
    );
  }
}